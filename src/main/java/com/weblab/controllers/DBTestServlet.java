package com.weblab.controllers;

import com.weblab.util.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/dbtest")
public class DBTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        PrintWriter out = resp.getWriter();
        resp.setContentType("text/plain");

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            if (conn != null) {
                out.println("SUCCESS: Database connection was successful!");
                out.println("Connection object: " + conn);
                out.println("\n========================================");
                out.println("TABLES IN DATABASE");
                out.println("========================================");
                
                // Get database metadata
                DatabaseMetaData metaData = conn.getMetaData();
                String[] types = {"TABLE"};
                
                // Retrieve all tables
                ResultSet tables = metaData.getTables(null, null, "%", types);
                
                int tableCount = 0;
                while (tables.next()) {
                    String tableName = tables.getString("TABLE_NAME");
                    String tableType = tables.getString("TABLE_TYPE");
                    out.println((++tableCount) + ". " + tableName + " (" + tableType + ")");
                }
                
                if (tableCount == 0) {
                    out.println("No tables found in the database.");
                } else {
                    out.println("\nTotal tables: " + tableCount);
                }
                
                out.println("========================================\n");
                
                // Display columns for each table
                tables = metaData.getTables(null, null, "%", types);
                while (tables.next()) {
                    String tableName = tables.getString("TABLE_NAME");
                    out.println("\nTable: " + tableName);
                    out.println("Columns:");
                    
                    ResultSet columns = metaData.getColumns(null, null, tableName, null);
                    int columnCount = 0;
                    while (columns.next()) {
                        String columnName = columns.getString("COLUMN_NAME");
                        String dataType = columns.getString("TYPE_NAME");
                        int columnSize = columns.getInt("COLUMN_SIZE");
                        String nullable = columns.getString("IS_NULLABLE");
                        
                        out.println("  - " + columnName + " (" + dataType + 
                                  (columnSize > 0 ? "(" + columnSize + ")" : "") + 
                                  ", Nullable: " + nullable + ")");
                        columnCount++;
                    }
                    columns.close();
                }
                
            } else {
                out.println("ERROR: DatabaseConnection.getConnection() returned null.");
            }
        } catch (SQLException e) {
            out.println("FAILURE: Could not connect to the database.");
            out.println("\n--- Error Details ---");
            out.println("SQL State: " + e.getSQLState());
            out.println("Error Code: " + e.getErrorCode());
            out.println("Message: " + e.getMessage());
            out.println("\n--- Stack Trace ---");
            e.printStackTrace(out);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace(out);
                }
            }
        }
    }
}
