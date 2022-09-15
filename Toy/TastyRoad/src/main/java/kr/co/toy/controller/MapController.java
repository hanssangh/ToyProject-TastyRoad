package kr.co.toy.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.co.toy.model.MapVO;
import kr.co.toy.service.MapService;

@Controller
@RequestMapping("/map/*")
public class MapController {
	
	@Autowired
	private MapService service;
	
	@GetMapping("/enter")
	public void enter() {
		System.out.println("enter");
	}
	
	@GetMapping("/list")
	@ResponseBody
	public List<MapVO> list() {
		System.out.println("list");
		return service.getList();
	}
	
	@PostMapping("/insert")
	@ResponseBody
	public String insert(@RequestBody MapVO vo) {
		System.out.println("insert");
		service.insert(vo);
		return "success";
	}

}
