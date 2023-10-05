<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page import="mybean.Board" %>
<jsp:useBean id="dao" class="mybean.BoardDao" />
<jsp:useBean id="dto" class="mybean.Board" />

<%
	request.setCharacterEncoding("EUC-KR"); 
%>
<!-- 부모글의 글번호를 dto에 받아놨다 -->
<jsp:setProperty property="*" name="dto"/>

	<!-- 사용자가 정보를 잘 입력 받았는지 -->
<% 
	/* dao.setBoard(dto); 글 저장할땐 setBoard */
	/* Board import */
	Board parent = dao.getBoard(dto.getB_num());
	dao.replyUpdatePos(parent);
	
	/* 0,0 으로 되어있는 것을 부모글의 pos, depth로 변경해줌 */
	dto.setPos(parent.getPos());
	dto.setPos(parent.getDepth());
	// 부모글의 글 번호
	dao.replyBoard(dto);
	response.sendRedirect("List.jsp");
%>