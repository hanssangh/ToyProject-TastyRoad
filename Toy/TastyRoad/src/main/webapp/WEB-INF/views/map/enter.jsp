<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tasty Road</title>

<link rel="stylesheet" href="<c:url value='/resources/css/main.css' />">
</head>
<body>

	<div class="wrapper">
		<div id="map" style="height: 100%;"></div>
		
		<div class="map-button">
			<button type="button" id="btn-new">신규</button>
		</div>
		
		<div class="modal-bg">
			<div class="modal">
				<div class="modal-header clearfix">
					<div class="left" id="cancel">취소</div>
					<div class="right" id="add">등록</div>
					<h2>신규 장소 등록</h2>
				</div>
				<div class="modal-body">
					<input type="hidden" name="lat">
					<input type="hidden" name="lng">
					이름 <br>
					<input type="text" name="name"> <br>
					위치 <br>
					<input type="text" name="addr1"> <br>
					<input type="text" name="addr2"> <br>
					메뉴 <br>
					<input type="text" name="menu">
				</div>
			</div>
		</div>
	</div>
	
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=ccbf0acb558cb47c54a38a6ebc1e20ce&libraries=services,clusterer,drawing"></script>
	<script>
	
		// 카카오 지도
		var mapContainer = document.getElementById('map'); // 지도를 담을 영역의 DOM 레퍼런스
		var mapOptions = { // 지도를 생성할 때 필요한 기본 옵션
			center: new kakao.maps.LatLng(37.456668761292136, 127.16029106668229), // 지도의 중심좌표.
			level: 3 //지도의 레벨(확대, 축소 정도)
		};
		var map = new kakao.maps.Map(mapContainer, mapOptions); // 지도 생성 및 객체 리턴
		
		var options = { // Drawing Manager를 생성할 때 사용할 옵션입니다
		    map: map, // Drawing Manager로 그리기 요소를 그릴 map 객체입니다
		    drawingMode: [ // drawing manager로 제공할 그리기 요소 모드입니다
		        kakao.maps.drawing.OverlayType.MARKER
		    ],
		    // 사용자에게 제공할 그리기 가이드 툴팁입니다
		    // 사용자에게 도형을 그릴때, 드래그할때, 수정할때 가이드 툴팁을 표시하도록 설정합니다
		    guideTooltip: ['draw', 'drag', 'edit'], 
		    markerOptions: { // 마커 옵션입니다 
		        draggable: true, // 마커를 그리고 나서 드래그 가능하게 합니다 
		        removable: true // 마커를 삭제 할 수 있도록 x 버튼이 표시됩니다  
		    }
		};
		// 위에 작성한 옵션으로 Drawing Manager를 생성합니다
		var manager = new kakao.maps.drawing.DrawingManager(options);
		
		// 주소-좌표 변환 객체를 생성합니다
		var geocoder = new kakao.maps.services.Geocoder();

		function searchDetailAddrFromCoords(coords, callback) {
		    // 좌표로 법정동 상세 주소 정보를 요청합니다
		    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
		}
		
		// 마커 표시
		window.onload = function() {
			const xhr = new XMLHttpRequest();
			xhr.onreadystatechange = () => {
				if(xhr.readyState === XMLHttpRequest.DONE) {
					if(xhr.status === 200) {
						const result = JSON.parse(xhr.response);
						
						result.forEach(item => {
							const markerPosition = new kakao.maps.LatLng(item.lat, item.lng);
							const marker = new kakao.maps.Marker({
								position: markerPosition
							});
							marker.setMap(map);
							
							// 마커에 표시할 인포윈도우를 생성합니다 
						    var infowindow = new kakao.maps.InfoWindow({
						        content: item.name // 인포윈도우에 표시할 내용
						    });

						    // 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
						    // 이벤트 리스너로는 클로저를 만들어 등록합니다 
						    // for문에서 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
						    kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(map, marker, infowindow));
						    kakao.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));
						    kakao.maps.event.addListener(marker, 'click', () => {
						    	document.querySelectorAll('.modal-body input').forEach(input => {
						    		Object.keys(item).forEach(key => {
						    			if(input.name === key) {
						    				input.value = item[key];
						    			}
						    		});
						    	});
						    	document.querySelector('.modal-bg').style.display = 'block';
						    });
						});
					}
					else {
						alert('문제가 있습니다.');
					}
				}
			};
			xhr.open('GET', '<c:url value="/map/list" />', true);
			xhr.send();
		}
		
		// 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
		function makeOverListener(map, marker, infowindow) {
		    return function() {
		        infowindow.open(map, marker);
		    };
		}

		// 인포윈도우를 닫는 클로저를 만드는 함수입니다 
		function makeOutListener(infowindow) {
		    return function() {
		        infowindow.close();
		    };
		}
		
		let flag = false;
		let lat = '';
		let lng = '';
		
		let addr1 = document.querySelector('.modal-body input[name="addr1"]');
		
		// 지도에 클릭 이벤트를 등록합니다
		// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
		kakao.maps.event.addListener(map, 'click', function(mouseEvent) {        
		    // 클릭한 위도, 경도 정보를 가져옵니다 
		    var latlng = mouseEvent.latLng;
		    
		    lat = latlng.getLat();
		    lng = latlng.getLng();
		    
		    manager.cancel();
		    
		    searchDetailAddrFromCoords(latlng, (result, status) => {
		    	if(status === kakao.maps.services.Status.OK) {
		    		if(result[0].road_address) {
		    			addr1.value = result[0].road_address.address_name;
		    		}
		    		else {
		    			addr1.value = result[0].address.address_name;
		    		}
		    	}
		    });
		    
		    // 모달 보이기
		    if(flag) {
		    	document.querySelector('.modal-bg').style.display = 'block';
		    	flag = false;
		    }
		});
		
		// 신규 버튼 클릭
		document.getElementById('btn-new').addEventListener("click", function() {
			flag = true;
			manager.select(kakao.maps.drawing.OverlayType['MARKER']);
		});
		
		// 모달 감추기
		document.querySelector('.modal-bg').addEventListener('click', function(e) {
			if(e.target.classList.contains('modal-bg')) {			
				e.currentTarget.style.display = 'none';
				addr1.value = '';
			}
		});
		document.getElementById('cancel').addEventListener('click', function() {
			document.querySelector('.modal-bg').style.display = 'none';
			addr1.value = '';
		});
		
		let info = {};
		let httpRequest;
		// 등록 통신
		document.getElementById('add').addEventListener('click', function() {
			const input = document.querySelectorAll('.modal-body input');
			input.forEach(item => {
				if(item.name === 'lat') {
					info.lat = lat;
				}
				else if(item.name === 'lng') {
					info.lng = lng;
				}
				else if(item.name === 'name') {
					info.name = item.value;
				}
				else if(item.name === 'addr1') {
					info.addr1 = item.value;
				}
				else if(item.name === 'addr2') {
					info.addr2 = item.value;
				}
				else if(item.name === 'menu') {
					info.menu = item.value;
				}
			});
			
			httpRequest = new XMLHttpRequest();
			httpRequest.onreadystatechange = () => {
				if(httpRequest.readyState === XMLHttpRequest.DONE) {
					if(httpRequest.status === 200) {
						alert('등록되었습니다.');
						
						input.forEach(item => item.value = '');
						document.querySelector('.modal-bg').style.display = 'none';
						
						window.onload();
					}
					else {
						alert('request에 문제가 있습니다.');
					}
				}
			};
			httpRequest.open('POST', '<c:url value="/map/insert" />', true);
			httpRequest.setRequestHeader('Content-Type', 'application/json');
			httpRequest.send(JSON.stringify(info));
		});
	
	</script>

</body>
</html>