package mybean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BoardDao {
	private Connection con;
	private PreparedStatement stmt;
	private ResultSet rs;
	private DataSource ds;
	
	public BoardDao() {
		try {
			Context ctx = new InitialContext();
			ds =(DataSource)ctx.lookup("java:comp/env/jdbc/myoracle");
		}
		
		catch(Exception err){
			System.out.println("BoardDao: " + err);
		}
	}
	
	public void freeConnection(){
		if(rs != null)
			try {
				rs.close();
			} catch (SQLException e) { e.printStackTrace(); }
		if(stmt != null)
			try {
				stmt.close();
			} catch (SQLException e) { e.printStackTrace(); }
		if(con != null)
			try {
				con.close();
			} catch (SQLException e) { e.printStackTrace(); }
	}
	
	// List.jsp 컬렉션 생성 index property 여서 자바코드로 해결해야한다 JSTL 배우기전엔 액션 태그불가능
	// public List getBoardList()
	public List getBoardList(String keyField, String keyWord) {
		// 에러날게 없으니까 try 밖으로 뺌
		String sql = null; 
		// 검색어 여부
		if(keyWord == null || keyWord.isEmpty()) {
				sql = "select b_num, b_subject, b_name, b_regdate, " +
						"b_count from tblboard order by b_num desc";
		}
		// 가장 최신순으로 내림차순
		else {
			sql = "select b_num, b_subject, b_name, b_regdate, " +
					"b_count from tblboard where " + keyField +
					" like '%" + keyWord +
					"%' order by b_num desc";
		}
		
		// List 자식이니까 Vector 가 동기화된 컬렉션이여서 안전하게 사용가능
		Vector vector = new Vector();
		
		try{
			con = ds.getConnection();
			stmt = con.prepareStatement(sql);
			// 실행 안 시켜주면 된다 이미 db 연결은 끝나서
			rs = stmt.executeQuery();
			
			// 글이 한개가 아니니까 컬렉션에 담을꺼다 
			while(rs.next()){
				Board board = new Board();
				board.setB_subject(rs.getString("b_subject"));
				board.setB_name(rs.getString("b_name"));
				board.setB_count(rs.getInt("b_count"));
				board.setB_num(rs.getInt("b_num"));
				board.setB_regdate(rs.getString("b_regdate"));
				
				// vector 라는 통에다가 board 를 하나씩 넣어준것
				vector.add(board);
			}
		}
		catch(Exception e) {
			System.out.println("getBoardList: " + e);
		}
		finally{
			freeConnection();
		}
		return vector;
	}
	
	// 기존에 입력된 값들의 pos +1
	public void updatePos(Connection con) {
		try {
		String sql = "update tblboard set pos = pos + 1";
		stmt = con.prepareStatement(sql);
		stmt.executeUpdate();
		}
		catch(Exception err) {
			System.out.println("updatePos : " + err);
		}
	}
	
	
	/** PostProc.jsp, ReplyProc.jsp 하나의 글을 묶어서 전달 **/
	public void setBoard(Board board) {
		String sql = "insert into tblboard(b_num, " +
				"b_name, b_email, b_homepage, b_subject, b_content, " +
				"b_pass, b_count, b_ip, b_regdate , pos, depth) " +
				"values(seq_b_num.nextVal, ?,?,?,?,?,?, 0, ?, sysdate , 0, 0)";
		try {
			con = ds.getConnection();
			
			updatePos(con);
			
			stmt = con.prepareStatement(sql);
			stmt.setString(1, board.getB_name());
			stmt.setString(2, board.getB_email());
			stmt.setString(3, board.getB_homepage());
			stmt.setString(4, board.getB_subject());
			stmt.setString(5, board.getB_content());
			stmt.setString(6, board.getB_pass());
			stmt.setString(7, board.getB_ip());
			stmt.executeUpdate();			
		}
		catch(Exception e){
			System.out.println("serBoard" + e);
		}
		finally {
			freeConnection();
			}
		}

	// Read.jsp, Update.jsp, Reply.jsp getBoard 메서드 하나로 2가지 jsp 에서 쓸 수 있음
	// 실제 화면에 뿌려주는거
	public Board getBoard(int b_num){
		String sql;
		Board result = new Board();
		
		try{
			con = ds.getConnection();
			
			sql = "select * from tblboard where b_num=?";
			stmt = con.prepareStatement(sql);
			stmt.setInt(1, b_num);
			rs = stmt.executeQuery();
			
			if(rs.next()){
				result.setB_content(rs.getString("b_content"));
				result.setB_count(rs.getInt("b_count"));
				result.setB_email(rs.getString("b_email"));
				result.setB_homepage(rs.getString("b_homepage"));
				result.setB_ip(rs.getString("b_ip"));
				result.setB_name(rs.getString("b_name"));
				result.setB_num(rs.getInt("b_num"));
				result.setB_pass(rs.getString("b_pass"));
				result.setB_regdate(rs.getString("b_regdate"));
				result.setB_subject(rs.getString("b_subject"));
			}
		}
		catch(Exception err){
			System.out.println("getBoard() : " + err);
		}
		finally{
			freeConnection();
		}
		
		return result;
	}
	
	// UpdateProc.jsp
	public void updateBoard(Board dto){
		String sql = "update tblboard set b_name=?, b_email=?, " +
			"b_subject=?, b_content=? where b_num=?";
		
		try{
			con = ds.getConnection();
			stmt = con.prepareStatement(sql);
			stmt.setString(1, dto.getB_name());
			stmt.setString(2, dto.getB_email());
			stmt.setString(3, dto.getB_subject());
			stmt.setString(4, dto.getB_content());
			stmt.setInt(5, dto.getB_num());
			
			stmt.executeUpdate();
		}
		catch(Exception err){
			System.out.println("updateBoard() : " + err);
		}
		finally{ freeConnection(); }
	}
	
	// Delete.jsp
	public void deleteBoard(int b_num){
		String sql = "delete from tblboard where b_num=?";
			
		try{
			con = ds.getConnection();
			stmt = con.prepareStatement(sql);
			stmt.setInt(1, b_num);
			stmt.executeUpdate();
		}
		catch(Exception err){
			System.out.println("deleteBoard() : " + err);
		}
		finally{ freeConnection(); }
	}
	
	public void replyBoard (Board board) {
		
	}
}
