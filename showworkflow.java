
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

public class showworkflow extends JFrame{
 
	Container cnt = this.getContentPane();
	DefaultTableModel model = new DefaultTableModel();
	JTable jtbl = new JTable(model);
	   
	static String s = new String();
	static StringBuffer sb = new StringBuffer();
    public showworkflow()
    {
    	 cnt.setLayout(new FlowLayout(FlowLayout.LEFT));
         model.addColumn("WorkFlowStepKey");
         model.addColumn("WorkFlowStepDescription");
         model.addColumn("WorkFlowStepTableRowCount");
         model.addColumn("StartingDateTime");
         model.addColumn("EndingDateTime");
         model.addColumn("Class Time");
         model.addColumn("UserAuthorizationKey");
    Connection db = null;
    String dburl = "jdbc:sqlserver://localhost:1433;databasename=BICLASS;integratedSecurity=true;";
    try
    {
    	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver").newInstance();
    	db = DriverManager.getConnection(dburl);
    	Statement stmt=db.createStatement();  
    	
    	ResultSet rs=stmt.executeQuery("truncate table Process.Workflowsteps; Alter Sequence PkSequence.WorkflowStepsSequenceObject RESTART WITH 1 exec [Project2].[LoadStarSchemaData] @userAuthorizationKey=4 EXEC [Process].[usp_ShowWorkflowSteps]"); 
    	String newline = System.getProperty("line.separator");
    	while(rs.next())  
    	{  //	System.out.format("%s%32s%n",rs.getString(1), rs.getString(2));
    		model.addRow(new Object[]{rs.getString(1),rs.getString(2),rs.getString(3),rs.getString(4),rs.getString(5),rs.getString(6),rs.getString(7)});
    	}
    	
    } catch(Exception e) {e.printStackTrace();}
    System.out.println("Connected");
    jtbl.setAutoResizeMode(JTable.AUTO_RESIZE_ALL_COLUMNS);
    JScrollPane pg = new JScrollPane(jtbl);
    pg.setPreferredSize(jtbl.getPreferredSize());
    cnt.add(pg);
    this.pack();
    }

     
    
 
        public static void main(String[] args) {
            JFrame frame = new showworkflow();
            frame.setTitle("Show Work Flow Process");
            frame.setPreferredSize(frame.getPreferredSize());;
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        }
    
}