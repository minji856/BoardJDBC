<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*" %>

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
// db로부터 가져온 결과를 저장해야해서 이때는 rs가 필요함
ResultSet rs = null;
	
String url = "jdbc:oracle:thin:@localhost:1521:xe";
String id = "scott";
String pw = "1111";

try{
	Class.forName("oracle.jdbc.driver.OracleDriver");
	con = DriverManager.getConnection(url, id, pw);
	
	// 업데이트 보다 우선 패스워드가 맞는지부터 확인부터해야함
	String sql = "select b_pass from tblboard where b_num=?";
	// db에 물음표에 전달할 값
	stmt = con.prepareStatement(sql);
	// 첫번째 물음표에 b_num
	stmt.setString(1, b_num);
	// 결과를 받아와야하니까 executeQuery
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
	if(stmt != null) stmt.close();
	if(con != null)	con.close();
	if(rs != null)	rs.close();
}
%>
