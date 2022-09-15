package kr.co.toy.mapper;

import java.util.List;

import kr.co.toy.model.MapVO;

public interface MapMapper {
	
	public List<MapVO> getList();
	
	public void insert(MapVO vo);
	
	public MapVO read(int no);
	
	public int delete(int no);
	
	public int update(MapVO vo);

}
