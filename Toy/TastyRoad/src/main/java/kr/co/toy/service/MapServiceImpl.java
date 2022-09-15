package kr.co.toy.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.toy.mapper.MapMapper;
import kr.co.toy.model.MapVO;

@Service
public class MapServiceImpl implements MapService {
	
	@Autowired
	private MapMapper mapper;

	@Override
	public List<MapVO> getList() {
		return mapper.getList();
	}

	@Override
	public void insert(MapVO vo) {
		mapper.insert(vo);
	}

	@Override
	public MapVO read(int no) {
		return mapper.read(no);
	}

	@Override
	public boolean delete(int no) {
		return mapper.delete(no) == 1;
	}

	@Override
	public boolean update(MapVO vo) {
		return mapper.update(vo) == 1;
	}

}
