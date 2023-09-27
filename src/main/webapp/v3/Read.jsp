<%@ page contentType="text/html; charset=EUC-KR"%>
<jsp:useBean id="dao" class="mybean.BoardDao" />
<jsp:useBean id="dto" class="mybean.Board" />
<html>
<head><title>JSPBoard</title>
<link href="style.css" rel="stylesheet" type="text/css">
</head>

<body>

<%
	String b_num = request.getParameter("b_num");
	
	String sql = "select * from tblboard where b_num=" + b_num;
	//dao.getBoardList(dto);
%>


<br><br>
<table align=center width=70% border=0 cellspacing=3 cellpadding=0>
 <tr>
  <td bgcolor=9CA2EE height=25 align=center class=m>글읽기</td>
 </tr>
 <tr>
  <td colspan=2>
   <table border=0 cellpadding=3 cellspacing=0 width=100%> 
    <tr> 
	 <td align=center bgcolor=#dddddd width=10%> 이 름 </td>
	 <td bgcolor=#ffffe8> <jsp:getProperty name="dto" property="b_name"/></td>
	 <td align=center bgcolor=#dddddd width=10%> 등록날짜 </td>
	 <td bgcolor=#ffffe8><jsp:getProperty name="dto" property="b_regdate"/></td>
	</tr>
    <tr>
	 <td align=center bgcolor=#dddddd width=10%> 메 일 </td>
	 <td bgcolor=#ffffe8 ><jsp:getProperty name="dto" property="b_name"/></td> 
	 <td align=center bgcolor=#dddddd width=10%> 홈페이지 </td>
	 <td bgcolor=#ffffe8 ><a href="http://" target="_new">http://
	 <jsp:getProperty name="dto" property="b_name"/></a></td> 
	</tr>
    <tr> 
     <td align=center bgcolor=#dddddd> 제 목</td>
     <td bgcolor=#ffffe8 colspan=3><jsp:getProperty name="dto" property="b_name"/></td>
   </tr>
   <tr> 
    <td colspan=4><jsp:getProperty name="dto" property="b_name"/></td>
   </tr>
   <tr>
    <td colspan=4 align=right>
    <jsp:getProperty name="dto" property="b_ip"/> 로 부터 글을 남기셨습니다./  
    조회수 : <jsp:getProperty name="dto" property="b_count"/>
    </td>
   </tr>
   </table>
  </td>
 </tr>
 <tr>
  <td align=center colspan=2> 
	<hr size=1>
	[ <a href="javascript:list()">목 록</a> | 
	<a href="Update.jsp?b_num=<%=b_num%>">수 정</a> |
	<a href="Delete.jsp?b_num=<%=b_num%>">삭 제</a> ]<br>
  </td>
 </tr>
</table>
</body>
</html>
