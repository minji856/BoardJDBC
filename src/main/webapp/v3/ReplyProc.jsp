<%@ page contentType="text/html; charset=euc-kr"%>
<jsp:useBean id="dao" class="mybean.BoardDao" />
<!-- �ϳ��� �Ѱ��ٲ� �ƴϴϱ� -->
<jsp:useBean id="dto" class="mybean.Board" />

<%
	request.setCharacterEncoding("EUC-KR"); 
%>
<!-- �̷��� �׼��±� ���°��̴� -->
<jsp:setProperty property="*" name="dto"/>

	<!-- ����ڰ� ������ �� �Է� �޾Ҵ��� -->
<% 
	dao.setBoard(dto);
	response.sendRedirect("List.jsp");
%>