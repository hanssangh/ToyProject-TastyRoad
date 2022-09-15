package kr.co.toy.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class MapVO {

	private int no;
	private String lat;
	private String lng;
	private String name;
	private String addr1;
	private String addr2;
	private String menu;
	
}
