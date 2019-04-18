
import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Container;
import java.awt.FlowLayout;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.sql.*;

import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumnModel;

public class showtotalexecutiontime extends JFrame{
 
	Container cnt = this.getContentPane();
	DefaultTableModel model = new DefaultTableModel();
	JTable jtbl = new JTable(model);
	   
	static String s = new String();
	static StringBuffer sb = new StringBuffer();
    public showtotalexecutiontime()
    {
    	 cnt.setLayout(new FlowLayout(FlowLayout.LEFT));
         model.addColumn("Total Execution Time in Seconds");

    Connection db = null;
    String dburl = "jdbc:sqlserver://localhost:1433;databasename=BICLASS;integratedSecurity=true;";
    try
    {
    	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver").newInstance();
    	db = DriverManager.getConnection(dburl);
    	Statement stmt=db.createStatement();  
    	
    	ResultSet rs=stmt.executeQuery("truncate table Process.Workflowsteps; Alter Sequence PkSequence.WorkflowStepsSequenceObject RESTART WITH 1 exec [Project2].[LoadStarSchemaData] @userAuthorizationKey=4 EXEC Process.usp_TotalExecutionTime"); 
    	String newline = System.getProperty("line.separator");
    	while(rs.next())  
    	{  //	System.out.format("%s%32s%n",rs.getString(1), rs.getString(2));
    		model.addRow(new Object[]{rs.getString(1)});
    	}
    } catch(Exception e) {e.printStackTrace();}
    System.out.println("Connected");
    jtbl.setAutoResizeMode(JTable.AUTO_RESIZE_ALL_COLUMNS);
    JScrollPane pg = new JScrollPane(jtbl);
   // pg.setPreferredSize(jtbl.getPreferredSize());
    cnt.add(pg);
    this.pack();
    }

     
    
 
        public static void main(String[] args) {
            JFrame frame = new showtotalexecutiontime();
            frame.setTitle("Show Total Execution Time");
           frame.setPreferredSize(frame.getPreferredSize());;
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        }
    
}