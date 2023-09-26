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
	
	// List.jsp 컬렉션 생성 indexproperty 여서 자바코드로 해결해야한다 jstl 배우기전엔 불가능
	public List getBoardList() {
		// 에러날게 없으니까 try 밖으로 뺌
		String sql = "select b_num, b_subject, b_name, b_regdate, b_count from tblboard";
		// List의 자식이니까 vector가 동기화된 컬렉션이여서 안전하게 사용가능
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
			System.out.println("BoardDao: " + e);
		}
		finally{
			freeConnection();
		}
		return vector;
	}
}
