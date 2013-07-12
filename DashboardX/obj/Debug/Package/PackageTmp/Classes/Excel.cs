using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

using Telerik.Web.UI;

namespace DashboardX
{
    public static class Excel
    {
        public static void FillGrid(RadGrid rg, DataSet ds)
        {
            // Build a table from the data.
            rg.DataSource = ds.Tables[0].DefaultView;
            rg.DataBind();
        }

        public static DataSet GetDataSetFromFile(string sFilename)
        {
            // Create connection string variable.
            string sConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;" + "Data Source=" + sFilename + ";" + "Extended Properties=Excel 8.0;";

            // Create the connection object by using the preceding connection string.
            OleDbConnection odb = new OleDbConnection(sConnectionString);

            // Open connection with the database.
            odb.Open();

            // Get the name of the first worksheet:
            DataTable dt = odb.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);

            if (dt == null || dt.Rows.Count < 1)
                throw new Exception("Error: Could not determine the name of the first worksheet.");

            string sFirstSheet = dt.Rows[0]["TABLE_NAME"].ToString();

            // The code to follow uses a SQL SELECT command to display the data from the worksheet.

            // Create new OleDbCommand to return data from worksheet.
            OleDbCommand objCmdSelect = new OleDbCommand("SELECT * FROM [" + sFirstSheet + "]", odb);

            // Create new OleDbDataAdapter that is used to build a DataSet 
            // based on the preceding SQL SELECT statement.
            OleDbDataAdapter objAdapter1 = new OleDbDataAdapter();

            // Pass the Select command to the adapter.
            objAdapter1.SelectCommand = objCmdSelect;

            // Create new DataSet to hold information from the worksheet.
            DataSet ds = new DataSet();

            // Fill the DataSet with the information from the worksheet.
            objAdapter1.Fill(ds, "XLData");

            // Build a table from the original data.
            //rg.DataSource = ds.Tables[0].DefaultView;
            //rg.DataBind();

            // Clean up objects.
            odb.Close();

            return ds;
        }

        // CONSOLIDATE THE LOGIC OF THESE TWO FUNCTIONS INTO THE ABOVE AND DETERMINE
        // THE TYPE OF FILE FROM THE EXTENSION!!!!!!!!!!!
        public static DataSet GetDataSetFromCSV(string path)
        {
            DataSet ds = new DataSet();
            DataTable dataTable = new DataTable();

            try
            {
                using (Stream stream = new FileStream(path, FileMode.Open))
                {
                    string sFirstLine;

                    using (StreamReader reader = new StreamReader(path))
                        sFirstLine = reader.ReadLine();

                    // Skip first line (headers) and read the rest of the file.
                    string[] csvRows = File.ReadAllLines(path).Skip(1).ToArray();

                    string[] headers = sFirstLine.Split(',');

                    // Adding columns name
                    foreach (var item in headers)
                        dataTable.Columns.Add(new DataColumn(item));

                    string[] fields = null;

                    foreach (string csvRow in csvRows)
                    {
                        //Debug.Write(csvRow+"\r\n");
                        fields = csvRow.Split(',');
                        DataRow row = dataTable.NewRow();
                        row.ItemArray = fields;
                        dataTable.Rows.Add(row);
                    }

                    ds.Tables.Add(dataTable);
                }
            }
            catch (Exception e)
            {
                /*DialogResult drResult = Program.Dialog(e.Message + " Try again?", MessageBoxButtons.RetryCancel);
                
                if (drResult == DialogResult.Retry)
                {
                    goto retry;
                }*/
            }

            if (ds != null)
                return ds;
            else
            {
                throw new Exception("Data set returned is null.");
                //return null;
            }
        }

        public static string GetStringFromDataTable(this DataTable table)
        {
            var result = new StringBuilder();
            for (int i = 0; i < table.Columns.Count; i++)
            {
                result.Append(table.Columns[i].ColumnName);
                result.Append(i == table.Columns.Count - 1 ? "\n" : ",");
            }

            foreach (DataRow row in table.Rows)
            {
                for (int i = 0; i < table.Columns.Count; i++)
                {
                    result.Append(row[i].ToString());
                    result.Append(i == table.Columns.Count - 1 ? "\n" : ",");
                }
            }
            return result.ToString();
        }

        public static string Save(this DataTable table)
        {
            return "";
        }
    }
}