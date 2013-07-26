using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;

public class SqlComm
{
    private object _result;
    
    private object Result
    {
        get
        {
            return _result;
        }
    }

    /// <summary>
    /// The connection string to use for queries.
    /// </summary>
    public static string ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["LocalConnectionString"].ConnectionString;

    public SqlComm()
    {
    }

    public SqlComm(string sConnectionString)
    {
        ConnectionString = sConnectionString;
    }
    
    /// <summary>
    /// Solely for executing a query with no value returned.
    /// </summary>
    /// <param name="sql">SQL query to execute.</param>
    public void Execute(string sql)
    {
        using (SqlConnection conn = new SqlConnection(ConnectionString))
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Connection.Open();
            cmd.ExecuteNonQuery();
        }
    }

    /// <summary>
    /// Executes a query and stores the result in the Result field.
    /// </summary>
    /// <param name="sql">SQL query to execute.</param>
    public void getResult(string sql)
    {
        using (SqlConnection conn = new SqlConnection(ConnectionString))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(sql, conn);
            object result = (object)cmd.ExecuteScalar();
            _result = result;
        }
    }

    /// <summary>
    /// Retrieve an entire database table or part of it and stores the result in the Result field.
    /// </summary>
    /// <param name="sql">SQL query to execute.</param>
    public void getDataTable(string sql)
    {
        using (SqlConnection conn = new SqlConnection(ConnectionString))
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Connection.Open();
            DataTable TempTable = new DataTable();
            TempTable.Load(cmd.ExecuteReader());
            _result = TempTable;
        }
    }

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
        using (SqlConnection conn = new SqlConnection(ConnectionString))
        {
            SqlCommand cmd = new SqlCommand(StoredProcedure, conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter(PrmName1, Param1.ToString()));
            cmd.Connection.Open();
            object obj = new object();
            obj = cmd.ExecuteScalar();
            _result = obj;
        }
    }
}