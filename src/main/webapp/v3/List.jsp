<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="mybean.*" %>
<%@ page import="java.util.*" %>

<%!
	int totalRecord = 0; // 총 글의 갯수
	int numPerPage = 20; // 한 페이지당 보여질 글의 갯수
	int totalPage = 0; // 총 페이지 수. 계산해서 나와야하니까 우선 0. 딱 맞아 떨어지지 않는다 짜투리 페이지
	int nowPage = 0; // 현재 페이지
	int beginPerPage = 0; // 페이지별 시작 번호
	int pagePerBlock = 2; // 블럭 당 페이지 수
	int totalBlock = 0; // 총 불륵 수
	int nowBlock = 0; // 현재 블럭
%>

<HTML>
<link href="style.css" rel="stylesheet" type="text/css">
<script>
	function check(){
		if(document.search.keyWord.value == ""){
			alert("검색어를 입력하세요.");
			document.search.keyWord.focus();
			return;
		}
		document.search.submit();
	}
</script>
<BODY>
<jsp:useBean id="dao" class="mybean.BoardDao"/>

<%
	request.setCharacterEncoding("euc-kr");
	String keyWord = request.getParameter("keyWord");	
		/* 검색어만 넘어오는게 아니고 제목,이름도 넘어온다 */
	String keyField = request.getParameter("keyField");
	
	Vector vec = (Vector)dao.getBoardList(keyField, keyWord);
	
	// 총 페이지
	totalRecord = vec.size();
	// 나머지가 있으면 그것도 한 페이지로 쳐야해서 무조건 숫자 올림
	totalPage = (int)Math.ceil((double)totalRecord / numPerPage);
	
	if(request.getParameter("nowPage") != null)
	// 문자열로 넘어오니까 int로 변환 null을 숫자로 나눌 수 없으니까 에러 떳음
		nowPage = Integer.parseInt(request.getParameter("nowPage"));

	if(request.getParameter("nowBlock") != null)
		nowBlock = Integer.parseInt(request.getParameter("nowBlock"));
	
	// 각각의 시작페이지
	beginPerPage = nowPage * numPerPage;
	totalBlock = (int)Math.ceil((double)totalPage / pagePerBlock);
	
%>

<center><br>
<h2>JSP Board</h2>

<table align=center border=0 width=80%>
<tr>
	<td align=left>Total :  Articles(
		<font color=red>  <%=nowPage + 1 %> / <%=totalPage %> Pages </font>)
	</td>
</tr>
</table>

<table align=center width=80% border=0 cellspacing=0 cellpadding=3>
<tr>
	<td align=center colspan=2>
		<table border=0 width=100% cellpadding=2 cellspacing=0>
			<tr align=center bgcolor=#D0D0D0 height=120%>
				<td> 번호 </td>
				<td> 제목 </td>
				<td> 이름 </td>
				<td> 날짜 </td>
				<td> 조회수 </td>
			</tr>
	<%
		//보드에 옮겨담는다  그 갯수만큼 글이 있을때에만 처리되어야한다 글 없으면 애러
		if(vec != null || !vec.isEmpty()){
		for(int i=beginPerPage; i<beginPerPage + numPerPage; i++){
			if(i == totalRecord)
				break;
			
			Board board = (Board)vec.get(i);
	%>
	<tr>
		<td><%=board.getB_num() %></td>
		<td>
			<%=dao.useDepth(board.getDepth()) %>
			<%
				if(board.getDepth() > 0){
			%>
				<img src="../images/re.gif"/>
			<%
			}
			%>
			<a href="Read.jsp?b_num=<%=board.getB_num()%>">
			<%=board.getB_subject() %></a></td>
		<td><%=board.getB_name()%></td>
		<td><%=board.getB_regdate() %></td>
		<td><%=board.getB_count() %></td>
	</tr>
	<%
		} // closing for
	} // closing if
	else{
	%>
		<b>데이터가 없습니다.</b>
	<%
	} 
	%>
		</table>
	</td>
</tr>
<tr>
	<td><BR><BR></td>
</tr>
<tr>
	<td align="left">Go to Page
	<% if(nowBlock > 0 ) { %>
		<a href="List.jsp?nowPage=<%=pagePerBlock * (nowBlock -1)%>&nowBlock=<%=nowBlock-1%>">이전 <%=pagePerBlock %>개</a> 
	<% } %>	
	:::	&nbsp;&nbsp;&nbsp; 
	<%
		for(int i=0; i<pagePerBlock; i++){
			if((nowBlock * pagePerBlock) + i == totalPage)
				break;
	%>
		
		<a href="List.jsp?nowPage=<%=(nowBlock * pagePerBlock) + i%>&nowBlock=<%=nowBlock%>">
			<%=(nowBlock * pagePerBlock) + i + 1 %>
		</a>&nbsp;&nbsp;&nbsp;
	<%		
		}
	%>
	&nbsp;&nbsp;&nbsp;	<!-- 프로그래밍에선 0 1 2 로 글이 처리되니까 +1 -->
	:::
	<!-- 사용자가 다음 페이지를 누르지 못하게끔 -->
	<% if(totalBlock > nowBlock +1) { %>
		<a href="List.jsp?nowPage=<%=pagePerBlock * (nowBlock +1)%>&nowBlock=<%=nowBlock+1%>">다음 <%=pagePerBlock %>개</a> 
	<% } %>
	</td>
	<td align=right>
		<a href="Post.jsp">[글쓰기]</a>
		<a href="javascript:list()">[처음으로]</a>
	</td>
</tr>
</table>
<BR>
<form action="List.jsp" name="search" method="post">
	<table border=0 width=527 align=center cellpadding=4 cellspacing=0>
	<tr>
		<td align=center valign=bottom>
			<select name="keyField" size="1">
				<option value="b_name"> 이름
				<option value="b_subject"> 제목
				<option value="b_content"> 내용
			</select>

			<input type="text" size="16" name="keyWord" >
			<input type="button" value="찾기" onClick="check()">
			<input type="hidden" name="page" value= "0">
		</td>
	</tr>
	</table>
</form>
</center>	
</BODY>
</HTML>