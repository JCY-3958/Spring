<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<%@ include file="../includes/header.jsp" %>
<style>
	.uploadResult {
		width:100%;
		background-color: gray;
	}
	
	.uploadResult ul{
		display:flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
		align-content: center;
		text-align: center;
	}
	
	.uploadResult ul li img {
		width: 100px;
	}
	
	.uploadResult ul li span {
		color:white;
	}
	
	.bigPictureWrapper {
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top:0%;
		width:100%;
		height:100%;
		background-color: gray;
		z-index: 100;
		background:rgba(255,255,255,0.5);
	}
	
	.bigPicture {
		position: relative;
		display:flex;
		justify-content: center;
		align-items: center;
	}
	
	.bigPicture img {
		width:600px;
	}
</style>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Tables</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board Register
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <form role="form" action="/board/register" method="post">
                            	<div class="form-group">
                            		<label>Title</label> <input class="form-control" name="title">
                            	</div>
                            	
                            	<div class="form-group">
                            		<label>Text Area</label>
                            		<textarea class="form-control" rows="3" name="content"></textarea>
                            	</div>
                            	
                            	<div class="form-group">
                            		<label>Writer</label> <input class="form-control" name="Writer">
                            	</div>
                            	<button type="submit" class="btn btn-default">Submit Button</button>
                            	<button type="reset" class="btn btn-default">Reset Button</button>
                            </form>
                        </div>
                        <!-- / end .panel-body -->
                    </div>
                    <!-- / end .panel -->
                </div>
                <!-- /.col-lg-6 -->
            </div>
            <!-- /.row -->
            
            <!-- file upload -->
            <div class="row">
            	<div class="col-lg-12">
            		<div class="panel panel-default">
            			<div class="panel-heading">File Attach</div>
            			<!-- /.panel-heading -->
            			<div class="panel-body">
            				<div class="form-group uploadDiv">
            					<input type="file" name='uploadFile' multiple>
            				</div>
            				
            				<div class='uploadResult'>
            					<ul>
            					
            					</ul>
            				</div>
            			</div>
            			<!-- end panel body -->
            		</div>
            		<!-- end panel default -->
            	</div>
            	<!-- end col-lg-12 -->
            </div>
            <!-- /.row -->
<script>
	//jQuery에서 매우 중요한 이벤트 핸들러.
	//이 함수 내에 정의된 코드는 전체 페이지가 브라우저에 의해
	//완전히 로드된 후에 실행됨.
	//header, footer, list 등 이런게 모두 완전히 로드된 후에 submit을 할 수 있음.
	$(document).ready(function(e) {
		var formObj = $("form[role='form']");
		
		$("button[type='submit']").on("click", function(e) {
			e.preventDefault();
			console.log("submit clicked");
			
			var str = "";
			
			$(".uploadResult ul li").each(function(i, obj) {
				var jobj = $(obj);
				console.dir(jobj);
				
				str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
			});
			formObj.append(str).submit();
		});
	});
	
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880;
	
	function checkExtension(fileName, fileSize) {
		if(fileSize >= maxSize) {
			alert("파일 사이즈 초과");
			return false;
		}
		
		if(regex.test(fileName)) {
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		return true;
	}
	
	//change는 jQuery의 이벤트 핸들러.
	//input, textarea, select 같은 폼 요소의 값이 사용자에 의해 변경되었을 때
	//발생하는 change 이벤트를 처리하는 데 사용됨.
	$("input[type='file']").change(function(e) {
		var formData = new FormData();
		
		//이 때 inputFile은 jQuery 객체 배열 형태임
		var inputFile = $("input[name='uploadFile']");
		
		//그래서 [0]은 jQuery 객체의 첫 번째 요소 (input 필드)를 순수한 javascript DOM 객체로 가져옴
		//.files는 사용자가 선택한 하나 이상의 파일에 대한 참조를 제공
		//이 속성이 FileList 객체를 반환하여 선택한 각 파일의 정보가 File 객체의 배열
		var files = inputFile[0].files;
		
		for(var i = 0; i < files.length; i++) {
			//File 객체의 속성으로 그냥 .name은 파일의 이름을 가져옴
			if(!checkExtension(files[i].name, files[i].size)) {
				return false;
			}
			formData.append("uploadFile", files[i]);
		}
		
		$.ajax({
			url: '/uploadAjaxAction',
			processData: false,
			contentType: false,
			data:formData,
			type:'POST',
			dataType:'json',
			success: function(result){
				console.log(result);
			showUploadResult(result); //업로드 결과 처리 함수
			}
		}); //$.ajax
	});
	
	function showUploadResult(uploadResultArr) {
		var str = "";
		
		if(!uploadResultArr || uploadResultArr.length == 0) { return;}
		
		var uploadUL = $(".uploadResult ul");
		
		$(uploadResultArr).each(
				//obj는 uploadResultArr들 중 하나들
				//uploadResultArr 애들은 위의 result에서 옴
				//그 result는 uploadController에서 주는데 attachDTO의 형태
				//따라서 uploadResultArr는 attachDTO의 리스트이고
				//obj는 each로 하나씩 꺼내지기 때문에 attachDTO 하나의 객체
				function(i, obj) {
					if(obj.image) {
						var fileCallPath = encodeURIComponent(obj.uploadPath+ "/s_"+ obj.uuid+ "_" + obj.fileName);
						str += "<li data-path='"+obj.uploadPath+"'";
						str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"'data-type='"+obj.image+"'";
						str += " ><div>";
						str += "<span>" + obj.fileName + "</span>";
						str += "<button type='button' data-file=\'"+fileCallPath+"\'data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
						str += "<img src='/display?fileName="+fileCallPath+"'>";
						str += "</div>";
						str += "</li>";
					} else {
						var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
						var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
						
						str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>";
						str += "<span> "+ obj.fileName + "</span>";
						str += "<button type='button' data-file=\'"+fileCallPath+"\'data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
						str += "<img src='/resources/img/attach.png'>";
						str += "</div>";
						str += "</li>";
					}
		});
		
		uploadUL.append(str);
	}
	
	$(".uploadResult").on("click", "button", function(e) {
		console.log("delete file");
		
		var targetFile = $(this).data("file");
		var type = $(this).data("type");
		
		var targetLi = $(this).closest("li");
		
		$.ajax({
			url: '/deleteFile',
			data: {fileName: targetFile, type:type},
			dataType:'text',
			type: 'POST',
			success: function(result) {
				alert(result);
				targetLi.remove();
			}
		}); //$.ajax
	});
</script>
<%@ include file="../includes/footer.jsp" %>