using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace DashboardX
{
    public class SqlComm
    {
        private static string _conn;

        /// <summary>
        /// The connection string to use for queries.
        /// </summary>
        public static string ConnectionString
        {
            get
            {
                return _conn;
            }
            set
            {
                _conn = value;
                conn = new SqlConnection(_conn);
            }
        }

        private List<object[]> _result;
        public List<object[]> Result
        {
            get
            {
                return _result;
            }
        }

        private static SqlConnection conn = new SqlConnection(ConnectionString);
        private SqlDataAdapter da = new SqlDataAdapter();
        public SqlConnection Connection
        {
            get
            {
                return conn;
            }
        }
        
        public SqlComm()
        {
            ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["LocalConnectionString"].ConnectionString;
            conn = new SqlConnection(ConnectionString);
        }

        public SqlComm(string sConnectionString)
        {
            ConnectionString = sConnectionString;
            conn = new SqlConnection(ConnectionString);
        }

        /// <summary>
        /// Solely for executing a query with no value returned.
        /// </summary>
        /// <param name="sql">SQL query to execute.</param>
        public void Execute(string sql)
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Connection.Open();
            cmd.ExecuteNonQuery();
        }

        /// <summary>
        /// Executes a query and stores the result in the Result field.
        /// </summary>
        /// <param name="sql">SQL query to execute.</param>
        public void getResult(string sql)
        {
            int i = 0;
            DataTable ds = new DataTable();
            List<object[]> result = new List<object[]>();

            conn.Open();

            da = new SqlDataAdapter(sql, conn);
            da.Fill(ds);

            foreach (DataRow row in ds.Rows)
            {
                result.Add(row.ItemArray);
            }

            _result = result;
        }

        /// <summary>
        /// Retrieve an entire database table or part of it and stores the result in the Result field.
        /// </summary>
        /// <param name="sql">SQL query to execute.</param>
        /*public void getDataTable(string sql)
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Connection.Open();
            DataTable TempTable = new DataTable();
            TempTable.Load(cmd.ExecuteReader());
            _result = TempTable;
        }*/

        /// <summary>
        /// You can use this in order to execute a stored procedure with 1 parameter.
        /// It will work for returning a value or just executing with no returns.
        /// The result will be stored in the Result field.
        /// </summary>
        /// <param name="StoredProcedure">The name of the stored procedure.</param>
        /// <param name="PrmName1">The name of the first parameter.</param>
        /// <param name="Param1">The parameter.</param>
        public void StoredProcedure(string StoredProcedure, string PrmName1, object Param1)
        {
            SqlCommand cmd = new SqlCommand(StoredProcedure, conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter(PrmName1, Param1.ToString()));
            cmd.Connection.Open();
            object obj = new object();
            obj = cmd.ExecuteScalar();
            //_result = obj;
        }
    }
}