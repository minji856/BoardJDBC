<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page import="mybean.Board" %>
<jsp:useBean id="dao" class="mybean.BoardDao" />
<jsp:useBean id="dto" class="mybean.Board" />

<%
	request.setCharacterEncoding("EUC-KR"); 
%>
<!-- �θ���� �۹�ȣ�� dto�� �޾Ƴ��� -->
<jsp:setProperty property="*" name="dto"/>

	<!-- ����ڰ� ������ �� �Է� �޾Ҵ��� -->
<% 
	/* dao.setBoard(dto); �� �����Ҷ� setBoard */
	/* Board import */
	Board parent = dao.getBoard(dto.getB_num());
	dao.replyUpdatePos(parent);
	
	/* 0,0 ���� �Ǿ��ִ� ���� �θ���� pos, depth�� �������� */
	dto.setPos(parent.getPos());
	dto.setPos(parent.getDepth());
	// �θ���� �� ��ȣ
	dao.replyBoard(dto);
	response.sendRedirect("List.jsp");
%>