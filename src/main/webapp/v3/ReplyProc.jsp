<%@ page contentType="text/html; charset=euc-kr"%>
<jsp:useBean id="dao" class="mybean.BoardDao" />
<!-- 하나만 넘겨줄꺼 아니니까 -->
<jsp:useBean id="dto" class="mybean.Board" />

<%
	request.setCharacterEncoding("EUC-KR"); 
%>
<!-- 이래서 액션태그 쓰는것이다 -->
<jsp:setProperty property="*" name="dto"/>

	<!-- 사용자가 정보를 잘 입력 받았는지 -->
<% 
	dao.setBoard(dto);
	response.sendRedirect("List.jsp");
%>