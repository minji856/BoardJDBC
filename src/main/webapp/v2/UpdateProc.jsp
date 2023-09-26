<%@page import="java.sql.*" %>
<%@page import="javax.sql.*" %>
<%@page import="javax.naming.ldap.InitialLdapContext"%>
<%@page import="javax.naming.Context"%>

<%@ page contentType="text/html; charset=EUC-KR"%>

<%
	request.setCharacterEncoding("euc-kr");
	
	String b_num = request.getParameter("b_num");
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	String subject = request.getParameter("subject");
	String content = request.getParameter("content");
	String pass = request.getParameter("pass");
	
	
	//out.println(name + ", " + email + ", " + subject +
	//		", " + content + ", " + pass);
	
	Connection con = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	Context ctx = new InitialLdapContext();
	DataSource ds = 
			(DataSource)ctx.lookup("java:comp/env/jdbc/myoracle");

try{
	con = ds.getConnection();
	
	String sql = "select b_pass from tblboard where b_num=?";
	stmt = con.prepareStatement(sql);
	stmt.setString(1, b_num);
	rs = stmt.executeQuery();
	rs.next();
	
	if(pass.equals(rs.getString("b_pass"))){
		sql = "update tblboard set b_name=?, b_email=?, b_subject=?, b_content=? " +
			"where b_num=?";
		stmt = con.prepareStatement(sql);
		stmt.setString(1, name);
		stmt.setString(2, email);
		stmt.setString(3, subject);
		stmt.setString(4, content);
		stmt.setString(5, b_num);
		stmt.executeUpdate();
	
		response.sendRedirect("List.jsp");
	}
	else{
%> <!-- 화면에 뿌려주는건 js 역할이니까 끊어주기 -->
	<script>
		alert("비밀번호가 틀렸습니다.");
		history.back();
	</script>
<%
	}
}
	catch(Exception e){
		System.out.println("UpdateProc.jsp: " + e);
	}
	finally{
		if(rs != null)rs.close();
		if(stmt != null)stmt.close();
		if(con != null)con.close();
	}
%>
