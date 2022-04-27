# -*- coding: utf-8 -*-
"""
/***************************************************************************
 Municipality MVT Generator

Script that starts the generation of a vector MBTiles pyramid for each
municipality of Catalonia
***************************************************************************/
"""

import os
import subprocess
import psycopg2
import dotenv


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
        self.pg_cur.execute("SELECT nommuni, codimuni FROM icgc_data.boundary_div_admin WHERE class = 'municipi' AND adminlevel IS NOT NULL limit 2;")
        return self.pg_cur.fetchall()

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

    def edit_dotenv(self, municipality_code):
        """

        :param municipality_code:
        :return:
        """
        dotenv_file = dotenv.find_dotenv()
        dotenv.load_dotenv(dotenv_file)
        dotenv.set_key(dotenv_file, "MBTILES_FILE", f"{municipality_code}.mbtiles")

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

    def main(self):
        """

        :return:
        """
        for record in self.pg_data:
            municipality_name = record[0]
            municipality_code = record[1]
            self.edit_dotenv(municipality_name)
            self.edit_sql(municipality_code)
            
        municipality_mvt_generator.close_pg_conn()


if __name__ == '__main__':
    print('Editing SQL and .env files...')
    municipality_mvt_generator = MunicipalityMVTGenerator()
    municipality_mvt_generator.main()
    print('SQL and .env files edited')
