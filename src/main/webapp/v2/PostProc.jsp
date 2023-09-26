<%@page import="java.sql.*" %>
<%@page import="javax.sql.*" %>
<%@page import="javax.naming.ldap.InitialLdapContext"%>
<%@page import="javax.naming.Context"%>

<%@ page contentType="text/html; charset=euc-kr"%>

<% 
	request.setCharacterEncoding("EUC-KR");
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	String home = request.getParameter("homepage");
	String subject = request.getParameter("subject");
	String content = request.getParameter("content");
	String pass = request.getParameter("pass");
	
/* 	out.println(name + ", " + email + ", " + home + ", "+ subject + ", "
			+ content + ", "+ pass); */
			
	Connection con = null;
	PreparedStatement stmt = null;
	Context ctx = new InitialLdapContext();
	DataSource ds = 
			(DataSource)ctx.lookup("java:comp/env/jdbc/myoracle");
	
	try{
		con = ds.getConnection();
		
		String sql = "insert into tblboard(b_num, " +
				"b_name, b_email, b_homepage, b_subject, b_content, " +
				"b_pass, b_count, b_ip, b_regdate , pos, depth) " +
				"values(seq_b_num.nextVal, ?,?,?,?,?,?, 0, ?, sysdate , 0, 0)";
		stmt = con.prepareStatement(sql);
		stmt.setString(1, name);
		stmt.setString(2, email);
		stmt.setString(3, home);
		stmt.setString(4, subject);
		stmt.setString(5, content);
		stmt.setString(6, pass);
		stmt.setString(7, request.getRemoteAddr());
		stmt.executeUpdate();
		
		response.sendRedirect("List.jsp");
	}
	catch(Exception e){
		System.out.println("PostProc.jsp: " + e);
	}
	finally{
		if(stmt != null)stmt.close();
		if(con != null)con.close();
		if(ctx != null)con.close();
		if(ds != null)con.close();
	}
%>