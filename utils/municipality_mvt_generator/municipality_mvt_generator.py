# -*- coding: utf-8 -*-
"""
/***************************************************************************
 Municipality MVT Generator

Script that starts the generation of a vector MBTiles pyramid for each
municipality of Catalonia
***************************************************************************/
"""

import os
import shutil
import subprocess
import unicodedata
import psycopg2
import dotenv
import json
from geojson import load


class MunicipalityMVTGenerator:

    def __init__(self):
        self.pg_conn = self.pg_connection()
        self.pg_cur = self.set_pg_cur()
        self.pg_data = self.set_pg_data()
        self.sql_files = self.set_sql_files()

    def pg_connection(self):
        """

        :return:
        """
        conn = None
        try:
            conn = psycopg2.connect(
                                    host="sfproces02.icgc.local",
                                    port=5433,
                                    database="openmaptiles",
                                    user="openmaptiles",
                                    password="openmaptiles")
            return conn
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)

    def set_pg_cur(self):
        """

        :return:
        """
        return self.pg_conn.cursor()

    def get_pg_cur(self):
        """

        :return:
        """
        return self.pg_cur

    def set_pg_data(self):
        """

        :return:
        """
        try:
            self.pg_cur.execute("select codimuni, nommuni, ST_AsGeoJson(ST_Transform(ST_Envelope(geometry), 4326)) "
                                "as geometry FROM historic.boundary_div_admin_20220518 WHERE class = 'municipi' "
                                "AND adminlevel IS NOT null limit 1")
            return self.pg_cur.fetchall()
        except Exception as e:
            print(e)

    def get_pg_data(self):
        """

        :return:
        """
        return self.pg_data

    def close_pg_conn(self):
        """


        :return:
        """
        if self.pg_conn is not None:
            self.pg_conn.close()

    def edit_dotenv(self, municipality_name, bbox):
        """

        :param municipality_name:
        :return:
        """
        dotenv_file = dotenv.find_dotenv()
        dotenv.load_dotenv(dotenv_file)

        dotenv.set_key(dotenv_file, "MBTILES_FILE", f"{municipality_name}.mbtiles")
        dotenv.set_key(dotenv_file, "BBOX", bbox)

    def copy_dotenv(self):
        """

        :return:
        """
        shutil.copyfile(r'.env', r'.env-muni')

    def edit_muni_dotenv(self):
        """

        :return:
        """
        # Read in the file
        with open('.env-muni', 'r') as file:
            env_data = file.read()

        # Replace the target string
        env_data = env_data.replace('MBTILES_FILE', 'MBTILES_FILE_MUNI')

        # Write the file out again
        with open('.env-muni', 'w') as file:
            file.write(env_data)

    def edit_sql(self, municipality_code):
        """

        :param municipality_code:
        :return:
        """
        for file in self.sql_files:
            lines = self.get_lines(file)
            for line in lines:
                if 'WHERE codimuni =' in line:
                    i = lines.index(line)
                    line_before = lines[i-1]
                    spaces = self.count_spaces(line_before)
                    lines[i] = f"{' ' * spaces}WHERE codimuni = '{municipality_code}'\n"   # add the same spaces as the line before
            self.write_lines(file, lines)

    def set_sql_files(self):
        """

        :return:
        """
        sql_files = []
        for root, dirs, files in os.walk(r'layers'):
            for filename in files:
                if filename.endswith('.sql'):
                    sql_file_path = os.path.join(root, filename)
                    sql_files.append(sql_file_path)

        return sql_files

    def get_lines(self, sql_file):
        """

        :param sql_file:
        :return:
        """
        with open(sql_file, 'r') as f:
            lines = f.readlines()

        return lines

    def write_lines(self, sql_file, lines):
        """

        :param sql_file:
        :param lines:
        :return:
        """
        with open(sql_file, 'w') as fw:
            fw.writelines(lines)

    def count_spaces(self, line):
        """

        :param line:
        :return:
        """
        return line.count(" ") - 1

    def normalize_municipality_name(self, municipality_name):
        """

        :param municipality_name:
        :return:
        """
        normalized_name = unicodedata.normalize('NFKD', municipality_name).encode('ascii', 'ignore').decode('utf-8')\
            .replace("'", "").replace(" ", "_").replace("-", "_").lower()
        return normalized_name

    def get_bounding_box(self, geometry):
        """

        :param geometry:
        :return:
        """
        geojson = json.loads(geometry)
        coordinates = geojson['coordinates'][0]
        bbox = coordinates[0] + coordinates[2]
        bbox = str(bbox).replace("[", "").replace("]", "").replace(" ", "")
        return bbox

    def main(self):
        """

        :return:
        """
        for record in self.pg_data:
            municipality_code = record[0]
            municipality_name = self.normalize_municipality_name(record[1])
            municipality_bbox = self.get_bounding_box(record[2])
            self.edit_dotenv(municipality_name,  municipality_bbox)
            self.copy_dotenv()
            self.edit_muni_dotenv()
            self.edit_sql(municipality_code)

        municipality_mvt_generator.close_pg_conn()


if __name__ == '__main__':
    municipality_mvt_generator = MunicipalityMVTGenerator()
    municipality_mvt_generator.main()
    subprocess.call(['chmod', '777', '.env'])
