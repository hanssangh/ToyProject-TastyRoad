package kr.co.toy.service;

import java.util.List;

import kr.co.toy.model.MapVO;

public interface MapService {

public List<MapVO> getList();
	
	public void insert(MapVO vo);
	
	public MapVO read(int no);
	
	public boolean delete(int no);
	
	public boolean update(MapVO vo);
	
}
