<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<script
  src="https://code.jquery.com/jquery-3.6.3.min.js"
  integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
  crossorigin="anonymous"></script>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta charset="UTF-8">
<title>게시판03_유저글작성(커뮤니티)</title>
    <!--[if lt IE 9]>
    <script src="js/html5shiv.js"></script>
    <![endif]-->
    
    <style>
    .insert-user-name{
    	color:#498dcc;
    	font-weight:bold;
    }
    
/* 레이아웃 외곽 너비 400px 제한*/
.wrap{
    max-width: 480px;
    margin: 0 auto; /* 화면 가운데로 */
    background-color: #fff;
    height: 100%;
    padding: 20px;
    box-sizing: border-box;

}
.reviewform #rev_content textarea{
    width: 100%;
    padding: 10px;
    box-sizing: border-box;
}
.rating .rate_radio {
    position: relative;
    display: inline-block;
    z-index: 20;
    opacity: 0.001;
    width: 60px;
    height: 60px;
    background-color: #fff;
    cursor: pointer;
    vertical-align: top;
    display: none;
}
.rating .rate_radio + label {
    position: relative;
    display: inline-block;
    margin-left: -4px;
    z-index: 10;
    width: 60px;
    height: 60px;
    background-image: url('/amigo/resources/img/starrate.png');
    background-repeat: no-repeat;
    background-size: 60px 60px;
    cursor: pointer;
    background-color: #f0f0f0;
}
.rating .rate_radio:checked + label {
    background-color: #ff8;
}

.warning_msg {
    display: none;
    position: relative;
    text-align: center;
    background: #ffffff;
    line-height: 26px;
    width: 100%;
    color: red;
    padding: 10px;
    box-sizing: border-box;
    border: 1px solid #e0e0e0;
}
   	
    </style>
    
    <script>
  //별점 마킹 모듈 프로토타입으로 생성
    function Rating(){};
    Rating.prototype.rate = 0;
    Rating.prototype.setRate = function(newrate){
        console.log('별점');
        this.rate = newrate;
        let items = document.querySelectorAll('.rate_radio');
        items.forEach(function(item, idx){
            if(idx < newrate){
                item.checked = true;
            }else{
                item.checked = false;
            }
        });
    }
    let rating = new Rating();//별점 인스턴스 생성
    
    document.addEventListener('DOMContentLoaded', function(){
        //별점선택 이벤트 리스너
        document.querySelector('.rating').addEventListener('click',function(e){
            let elem = e.target;
            if(elem.classList.contains('rate_radio')){
                rating.setRate(parseInt(elem.value));
            }
        })
    });
    
    //상품평 작성 글자수 초과 체크 이벤트 리스너
    console.log('초과체크');
    document.querySelector('.review_textarea').addEventListener('keydown',function(){
        //리뷰 400자 초과 안되게 자동 자름
        let review = document.querySelector('.review_textarea');
        let lengthCheckEx = /^.{400,}$/;
        if(lengthCheckEx.test(review.value)){
            //400자 초과 컷
            review.value = review.value.substr(0,400);
        }
    });

    //저장 전송전 필드 체크 이벤트 리스너
    document.querySelector('#save').addEventListener('click', function(e){
        //별점 선택 안했으면 메시지 표시
        if(rating.rate == 0){
            rating.showMessage('rate');
            return false;
        }
        //리뷰 5자 미만이면 메시지 표시
        if(document.querySelector('.review_textarea').value.length < 5){
            rating.showMessage('review');
            return false;
        }
        //폼 서밋
    });
       
    
</script>
    
</head>
<body>
	
	<%@include file="/includes/header.jsp" %>
	<div class="wrap" align="center">
		<form name="reviewform" action="user_review_insert.do" method="post" enctype="multipart/form-data" onSubmit="return checkResult()">
            <input name="sit_no" type="hidden" value="${svo.sit_no}" />
            <input name="user_name" type="hidden" value="${svo.user_name}" />
            <input name="user_photo" type="hidden" value="${sessionScope.user.user_photo}" />
			<input name="user_no" type="hidden" value="${sessionScope.user.user_no}" />
			<input name="user_addr" type="hidden" value="${sessionScope.user.user_addr}" />
			<input name="user_name" type="hidden" value="${sessionScope.user.user_name}" />

			<!-- 작성자  -->
			<div class="input-group mb-3">
			 <input type="hidden" class="col-md-1 control-label" name="user_nick" value="${ sessionScope.user.getUser_nick() }" >
			 <span class="insert-font col-md-1" style="font-size:18px; font-weight:bold;" >작성자 </span> &nbsp;<p class="insert-user-name" style="font-size:18px; font-weight:bold;">${ user.getUser_nick() }</p>&nbsp;&nbsp;&nbsp;
			 <span class="insert-font col-md-1" style="font-size:18px; font-weight:bold;" >펫시터 </span> &nbsp;<p class="insert-sitter-name" style="font-size:18px; font-weight:bold;">${ svo.getUser_name() }</p>
			</div>
			<!-- 작성자  끝 -->
			<input type="hidden" name="rate" id="rate" value="0"/>
		 <div class="review_rating">
            <div class="warning_msg">별점을 선택해 주세요.</div>
            <div class="rating">
                <!-- 해당 별점을 클릭하면 해당 별과 그 왼쪽의 모든 별의 체크박스에 checked 적용 -->
                <input type="checkbox" name="rating" id="rating1" value="1" class="rate_radio" title="1점">
                <label for="rating1"></label>
                <input type="checkbox" name="rating" id="rating2" value="2" class="rate_radio" title="2점">
                <label for="rating2"></label>
                <input type="checkbox" name="rating" id="rating3" value="3" class="rate_radio" title="3점" >
                <label for="rating3"></label>
                <input type="checkbox" name="rating" id="rating4" value="4" class="rate_radio" title="4점">
                <label for="rating4"></label>
                <input type="checkbox" name="rating" id="rating5" value="5" class="rate_radio" title="5점">
                <label for="rating5"></label>
            </div>
        </div>
			<!-- 상단 끝 -->
			
			<hr/>
			<div class="review_contents">
			   		<div class="warning_msg">5자 이상으로 작성해 주세요.</div>	
			   		<textarea class="review_textarea" id="rev_content" name="rev_content" rows="10"  required ></textarea>		
			</div>	
			

			
		  
			<input type="hidden" name="ubd_file" value=""/>	
			<div class="row justify-content-evenly mt-5 mb-5">
				<input type="button" class="btn btn-primary col-2" value="취소" onclick="history.go(-1)"/>
				<input type="submit" class="btn btn-primary col-2" id="save" value="등록완료"/>
			</div>
		</form>			
	</div>
	<%@include file="/includes/footer.jsp" %>

	
</body>
</html>