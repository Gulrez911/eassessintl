<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page session="false"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.assessment.data.*, java.text.*, java.util.*" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>eAssess</title>
      	<link href="./resources/images/E-assess_E.png" rel="shortcut icon">   
        <link href="https://fonts.googleapis.com/css?family=Segoe+UI" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
        <link href="css/font-awesome.css" rel="stylesheet" type="text/css">
        <link href="css/style.css" rel="stylesheet" type="text/css">
        <link href="css/responsive.css" rel="stylesheet" type="text/css">
	<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
	<link href="css/pnotify.custom.min.css" rel="stylesheet" type="text/css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="scripts/pnotify.custom.min.js"></script>
    </head>

    <body>

        <div class="maincontainer">            

            <div class="wrapper">
                <div class="row row-offcanvas row-offcanvas-left">
                    <!-- sidebar -->
		   <%
					User user = (User) request.getSession().getAttribute("user");
					System.out.println("user is "+user.getEmail() );
						if(user == null){
								response.sendRedirect("login");
						}
					
					if(user.getUserType().getType().equals("LMS_ADMIN")){
						
						System.out.println("LMS_ADMIN true");
				  %>
					<jsp:include page="side_lms_admin.jsp" /> 
				   <%	  
					}
					else{
					%>
					<jsp:include page="side.jsp" /> 
					<%
					}
					%>
                 
                    <!-- /sidebar -->

                    <!-- main right col -->
                    <div class="column col-sm-10 col-xs-11" id="main">

                        <div class="rightside">
                            <div class="topmenu text-right">
                                <a href="addQuestion">Add New</a>
				<a href="javascript:showFileDialog();" id="uploadQuestionsLink">Import</a>
				<a href="javascript:showFileDialog1();" id="uploadQuestionsLink">Fill_Blank_Q</a>
				<a href="javascript:showFileDialog2();" id="uploadQuestionsLink">Fill_Matcher_Q</a>
				<a href="signoff">Sign Off</a>
					
				<form id="fileFormQuestions" method="POST" enctype="multipart/form-data" >
					<input type="file" name="fileQuestions" id="fileQuestions" style="display:none" />
					<input type="file" name="fileQuestions1" id="fileQuestions1" style="display: none" />
					<input type="file" name="fileQuestions2" id="fileQuestions2" style="display: none" />
				</form>
					
				
				
                                <div class="pagination">
                                	<c:if test="${showPreviousPage}">
                                    	<a href="${callingMethod}?page=${previousPage}${queryParam}"><i class="fa fa-arrow-left"></i></a>
                                    </c:if>
				    
				     <c:if test="${selectedPage != null &&  selectedPage > 0}">
	                                    ${selectedPage} / ${totalNumberOfPages}
                                    </c:if>
                                    
                                    <c:if test="${showNextPage}">
	                                    <a href="${callingMethod}?page=${nextPage}${queryParam}"><i class="fa fa-arrow-right"></i></a>
                                    </c:if>
                                </div>
								
                            </div>
							

                            <div class="questiontable">
                                <div class="questionheading">
                                    <div class="left">
                                        <h3>Question Bank</h3>
                                    </div>
                                    <div class="right">
                                        <div class="searchdata">
                                            <input type="text" placeholder="Search a question" name="searchText" id="searchText">
                                            <i class="fa fa-search" id="search"></i>
                                        </div>

                                        <div class="filter">
                                            <a href="javascript:notify('Information', 'Feature coming soon')"><img src="./resources/images/ic_sort.png">Sort</a>
                                            <a href="javascript:notify('Information', 'Feature coming soon')"><img src="./resources/images/ic_filter.png">Filter</a>
											 &nbsp; <a href="question_list" title="Click to view all Question Categories"><i class="fa fa-mail-reply-all"></i> </a>
                                        </div>

                                    </div>
                                </div>


                                <div class="questiontablelist" style="overflow-x:scroll;height:500px;">
                                    <table class="table">
                                        <thead>
                                            <tr>
						<th>No</th>
                                                <th>Question</th>
                                                <th  style="white-space:nowrap;">Category</th>
                                                <th>Difficulty Level</th>
                                                <th  style="white-space:nowrap;">Updated On</th>
						<th  style="white-space:nowrap;">Update</th>
						<th  style="white-space:nowrap;">Delete</th>
                                            </tr>
                                        </thead>
                                        <tbody>
					<tbody>
						                     
						                       <c:forEach  items="${qs}" var="question" varStatus="loop">   
						                      	<tr>

										<td>${loop.count}</td>		

												
						                      		<td><c:out value="${question.questionText}"></c:out>  </td>
										
						                      		<td> ${question.category}</td>
						                      		<td><c:out value="${question.difficultyLevel.level}"></c:out>   </td>
						                      		<td><c:out value="${question.updatedDate}"></c:out>   </td>
						                      		<td><a  href="addQuestion?qid=${question.id}">Click </a>   </td>
						                      		<td><a  href="javascript:confirm('${question.id}')">Click </a> </td>
						                      	</tr>
						                      	</c:forEach>   
						                      </tbody>
                                           
                                        </tbody>
                                    </table>
                                </div>

                            </div>

                        </div>

                    </div>
                    <!-- /main -->
                </div>
            </div>

        </div>
     <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>



        <script>
            /* off-canvas sidebar toggle */
            $('[data-toggle=offcanvas]').click(function () {
                $('.row-offcanvas').toggleClass('active');
                $('.collapse').toggleClass('in').toggleClass('hidden-xs').toggleClass('visible-xs');
            });
	    
	    $('#search').on('click',function(){
	    var text = document.getElementById("searchText").value;
		if(text.length != 0){
		window.location="searchQuestions?searchText="+text;
		}
	    });
	    
	    var isXlsx = function(name) {
	    return name.match(/xlsx$/i) || name.match(/xls$/i)
	    };
	    
	    $("#btnfile").click(function () {
	    $("#uploadfile").click();
	});
	
	
	function showFileDialog(){
		$("#fileQuestions").click();
	}
	
	function showFileDialog1() {
		$("#fileQuestions1").click();
	}
	
	function showFileDialog2() {
		$("#fileQuestions2").click();
	}
	    
	    $(document).ready(function() {
	    
	    var file = $('[name="fileQuestions"]');
	    var imgContainer = $('#imgContainer');
	    
	    $('#uploadLink').on('click', function() {
		// $("#file").click();
		
		});
		
		
		
		var fileU = document.getElementById('fileQuestions');
		fileU.addEventListener("change", function () {
			  if (fileU.files.length > 0) {
			   var filename = $.trim(file.val());
			
			if (!(isXlsx(filename) )) {
				notify('Error', 'Please select an xlsx file to upload');
				return;
			}
			
			$.ajax({
			   xhr: function() {
				var xhr = new window.XMLHttpRequest();

			  

				return xhr;
			  },
			   url: 'upload',
				type: "POST",
				data: new FormData(document.getElementById("fileFormQuestions")),
				enctype: 'multipart/form-data',
				processData: false,
				contentType: false
			  }).done(function(data) {
				notify('Success', 'File Upload Successful');
			   
			  }).fail(function(jqXHR, textStatus) {
				  notify('Failure', 'File Upload Failed. Please contact Administrator');
			  });
			  document.getElementById('fileQuestions').value = null;
				return;
			  }
			 
			});
	  
	});
	
	
	//fill in the blanks
	$(document).ready(function() {

					var file = $('[name="fileQuestions1"]');
					var fileU = document.getElementById('fileQuestions1');
					fileU.addEventListener("change",function() {
						if (fileU.files.length > 0) {
							var filename = $.trim(file.val());

							if (!(isXlsx(filename))) {
								notify('Error',	'Please select an xlsx file to upload');
								return;
							}

						$.ajax({
							xhr : function() {
												var xhr = new window.XMLHttpRequest();

												return xhr;
											},
											url : 'uploadFillBlank',
											type : "POST",
											data : new FormData(
													document
															.getElementById("fileFormQuestions")),
											enctype : 'multipart/form-data',
											processData : false,
											contentType : false
										})
								.done(function(response) {
									console.log(response.error);
									if(response.hasOwnProperty('error')){
										//window.location='errorUpload';
										//console.log(response.error);
										var err = response.error;
										err = err.replace(/"/g, '\\\"');
										notify('Information', err);
									}
									else{
										notify('Success','File Upload Successful');
									}
											

										})
								.fail(
										function(
												jqXHR,
												textStatus) {
											notify(
													'Failure',
													'File Upload Failed. Please contact Administrator');
										});
						document
								.getElementById('fileQuestions1').value = null;
						return;
					}

				});
			});
	//end fill in blanks
	
	//start match the following
	$(document).ready(function() {

					var file = $('[name="fileQuestions2"]');
					var imgContainer = $('#imgContainer');

					

					var fileU = document.getElementById('fileQuestions2');
					fileU.addEventListener("change", function() {
						if (fileU.files.length > 0) {
							var filename = $.trim(file.val());

							if (!(isXlsx(filename))) {
								notify('Error',
										'Please select an xlsx file to upload');
								return;
							}

							$.ajax({
								xhr : function() {
													var xhr = new window.XMLHttpRequest();

													return xhr;
												},
												url : 'uploadMacherQuestion',
												type : "POST",
												data : new FormData(
														document.getElementById("fileFormQuestions")),
												enctype : 'multipart/form-data',
												processData : false,
												contentType : false
											})
									.done(function(response) {
										console.log(response.error);
										if(response.hasOwnProperty('error')){
										//window.location='errorUpload';
										//console.log(response.error);
											var err = response.error;
											err = err.replace(/"/g, '\\\"');
											notify('Information', err);
										}
										else{
											notify('Success','File Upload Successful');
										}
										
											})
									.fail(
											function(
													jqXHR,
													textStatus) {
												notify(
														'Failure',
														'File Upload Failed. Please contact Administrator');
											});
							document
									.getElementById('fileQuestions2').value = null;
							return;
						}
					});
			  });
	//end matc the following
	
		function notify(messageType, message){
		 var notification = 'Information';
			 $(function(){
				 new PNotify({
				 title: notification,
				 text: message,
				 type: messageType,
				 styling: 'bootstrap3',
				 hide: true
			     });
			 }); 	
		}
		
		function confirm(id) {
           (new PNotify({
		    title: 'Confirmation Needed',
		    text: 'Are you sure? Do you really want to delete this Q?',
		    icon: 'glyphicon glyphicon-question-sign',
		    hide: false,
		    confirm: {
			confirm: true
		    },
		    buttons: {
			closer: false,
			sticker: false
		    },
		    history: {
			history: false
		    }
		})).get().on('pnotify.confirm', function() {
		    window.location = "removeQuestionFromList?qid="+id;
		}).on('pnotify.cancel', function() {
		   
		});
        }
	
     
		    
        </script>

	
	<c:if test="${msgtype != null}">
		 <script>
		 var notification = 'Information';
		 $(function(){
			 new PNotify({
			 title: notification,
			 text: '${message}',
			 type: '${msgtype}',
			 styling: 'bootstrap3',
			 hide: true
		     });
		 }); 	 
	      </script>
	</c:if>
    </body>
</html>
