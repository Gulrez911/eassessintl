<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.assessment.data.*, java.text.*, java.util.*,com.assessment.web.dto.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
 <title>eAssess</title>
      <link href="images/E-assess_E.png" rel="shortcut icon">
	<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Open+Sans+Condensed:wght@300&display=swap">
	<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
	<link rel="stylesheet" href="css_new/bootstrap.min.css">
	<link rel="stylesheet" href="css_new/styles_new.css">
	<link href="css/responsive.css" rel="stylesheet" type="text/css">
	<link href="css/font-awesome_new.css" rel="stylesheet" type="text/css">
	<link href="css/responsive_new.css" rel="stylesheet" type="text/css">
	<link href="css_new/pnotify.custom.min.css" rel="stylesheet" type="text/css">
		
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="scripts/custom.js"></script>
	<script type="text/javascript" src="scripts/pnotify.custom.min.js"></script>
	<script type="text/javascript" src="scripts/pnotify.nonblock.js"></script>
	<script type="text/javascript" src="scripts/pnotify.buttons.js"></script>
	<script src="scripts/src-min-noconflict/ace.js" type="text/javascript" charset="utf-8"></script>		
	<script type="text/javascript">
		// PNotify.prototype.options.styling = "fontawesome";
		var correctNumberOfChoices = ('${currentQuestion.questionMapperInstance.questionMapper.question.rightChoices}'.match(/-/g) || []).length  + 1;		var active = 'true';
		var studentNameTaken = localStorage.getItem('${studentTestForm.firstName}${studentTestForm.lastName}');
		var testNameTaken = localStorage.getItem('testName-${studentTestForm.firstName}${studentTestForm.lastName}');
		var tc= localStorage.getItem('timeCounter-${studentTestForm.firstName}${studentTestForm.lastName}');
		var firsttime = '${firstpage}';

		// console.log('firsttime '+firsttime);
			if(firsttime != null && firsttime == 'yes'){
				console.log('timeCounter getting');	
				timeCounter = ${timeCounter};
			} else {
				if(studentNameTaken == 'yes' && testNameTaken == '${studentTestForm.firstName}${studentTestForm.lastName}-${studentTestForm.testName}'  && tc != null){
				timeCounter=tc;
				}
				else{
					timeCounter = 0;
				}
				
				if(tc == null){
					timeCounter= 0;
				}
			
			}
			
			/***/
		
		
			if(timeCounter == null){
				timeCounter = 0;
			}
		console.log('timeCounter getting '+timeCounter);	
		console.log('timeCounter is '+timeCounter);
			
		function setTimeOnLoad(){
		timeProcess();
		}	
		
		function timeProcess(){
		if(timeCounter == null){
				timeCounter = 0;
		}
		timeCounter = parseInt(timeCounter) + 1;
		var end = new Date();
		var hours =  (${studentTestForm.duration}/60) % 60;
		var minutes = (${studentTestForm.duration}) % 60;
		var seconds = (${studentTestForm.duration} * 60) % 60;
		
		end.setMinutes(minutes);
		end.setHours(hours);
		end.setSeconds(seconds);
		
		var start = new Date();
		start.setMinutes((timeCounter/60) % 60);
		start.setHours((timeCounter/(60*60)) % 60);
		start.setSeconds(timeCounter % 60);
		
		var t = Date.parse(end) - Date.parse(start);
		seconds = Math.floor( (t/1000) % 60 );
		minutes = Math.floor( (t/1000/60) % 60 );
		hours = Math.floor( (t/(1000*60*60)) % 24 );
		
		 if (hours   < 10) {hours   = "0"+hours;}
		 
		  if (minutes < 10) {minutes = "0"+minutes;}
		  
		   if (seconds < 10) {seconds = "0"+seconds;}
		
		//document.getElementById("examTimer").innerHTML = hours+":"+minutes+":"+seconds;
		document.getElementById("hours").value = hours;
		document.getElementById("min").value = minutes;
		document.getElementById("sec").value = seconds;

		}
		 	
		var submitTest = 'false';
		
		function examTimer(){
			/**
			send notiication 10 mins before test
			**/
			sendNotification10MinBeforeTime();
			/**
			End 
			**/
			
			if(submitTest == 'true'){
				return;
			}
			timeProcess();
		
			if((${studentTestForm.duration} * 60) - timeCounter <= 3 ){
				notify('Info', 'Test Time exceeding shortly! Your test will be auto submitted. DO NOT REFRESH THE PAGE.');
			}		
				
			if( timeCounter >= (${studentTestForm.duration} * 60)  ){
			submitTest();
			}
		}
		
		var notificationsend = false;
		
		function sendNotification10MinBeforeTime(){
			//if(!notificationsend){
				var time = localStorage.getItem('not10min-${studentTestForm.emailId}-${studentTestForm.testName}');
				var diffInMinutes = null;
				if(time != null){
					var d1 = new Date();
					var n1 = d1.valueOf();
					diffInMinutes = Math.floor( (n1 - time) / 60000);
				}
				
				
				if((${studentTestForm.duration} * 60) - timeCounter <= 600 ){
					console.log('trying to notify 10 minutes before diffInMinutes is '+diffInMinutes);
					if(diffInMinutes == null || diffInMinutes >= 3){
						console.log('notify 10 minutes before');
					var d = new Date();
					var n = d.valueOf();
					localStorage.setItem('not10min-${studentTestForm.emailId}-${studentTestForm.testName}', n);
				
					tme = (${studentTestForm.duration} * 60) - timeCounter;
					mnts =(tme/60) % 60;
					notify('Info', 'You have about '+Math.round(mnts)+' minutes to complete the test');
					notificationsend = true;
						
					}
					
				}
			//}
			
		}
		
		
		function updateTimeInBackEnd(){
			<%
			Test test = (Test) request.getSession().getAttribute("test");
			%>
			var testid = '<%= test.getId() %>';
			var cid = '${studentTestForm.companyId}';
			var emailid = '${studentTestForm.emailId}';
			 var url = "timecounterUpdate?timecounter="+timeCounter+"&testId="+testid+"&email="+emailid+"&companyId="+cid;
			console.log('here url '+url);
			$.ajax({
				url : url,
				type: "POST",
				success : function(data) {
				console.log(' updateTimeInBackEnd ret '+data);
					
				},
				error : function(e) {
					console.log("ERROR: ", e);
					
				}
			});
		}
			
		function takeScreenShot(){
			 if(active == 'false'){
				//noncompCount ++;
				
				<!--notify('Info', 'The exam window looks to be in the background. This is a non-compliance. We are recording it in our system. If non-'+ -->

	<!-- 'compliances count exceeds 3, this test will auto-submit. Please beware! '); -->
	notify('Info', 'The exam window appears to be in the background. This is a non-compliance. We are recording it in our system and this might impact your score.');
				var datasend="user=${studentTestForm.emailId}\ntestName=${studentTestForm.testName}\ncompanyId=${studentTestForm.companyId}";
				$.ajax({
				    type: "POST",
				    url: "registerNonCompliance",
				    data: { 
					data:datasend
				    }
				}).done(function(fileName) {
					//alert("done");

				}); 
				
				
				//submitTest();
				//$.ajax({
				//    type: "POST",
				//    url: "getNonComplianceCount",
				//    data: { 
				//	data:datasend
				//    }
				//}).done(function(data) {
					//alert("done");
				//	console.log('no of non-compliances '+data);
						//if(data > 2){
						//	console.log('submiting because of many non-compliances');
						//	submitTest();
							
						//}
					
				//}); 
				
				
			}
			else if(active == 'true'){
				/* this.window.focus();
				 html2canvas(document.querySelector("#screenShotId"), {
				logging: true,
				allowTaint: true
			    }).then(function(canvas) {
				var dataImage = canvas.toDataURL("image/png");
				var testname = encodeURIComponent('${studentTestForm.testName}');
				$.ajax({
				    type: "POST",
				    url: "uploadScreenSnapShot?testName="+testname,
				    data: { 
					data:dataImage
				    }
				}).done(function(fileName) {
					alert("done");

				}); 
			    }); */
			} 
		
		
		}
		
		function activeScreen(){
		active = 'true';
		//alert(' active ' +active);
		}
		
		function passiveScreen(){
		active = 'false';
		//alert(' passicve ' +active);
		}
		
		
		window.addEventListener('focus', activeScreen);
		window.addEventListener('blur', passiveScreen);

		
		var myVar = setInterval(examTimer, 1000);
		//var myVar2 = setInterval(takeScreenShot, 5000);
		
		var myVar3 = setInterval(updateTimeInBackEnd, 45000);
		
	</script>
</head>
<body id="bodyid" class="post-login" onload="setTimeOnLoad();">
<%
QuestionInstanceDto dto = (QuestionInstanceDto)request.getAttribute("currentQuestion");
//System.out.println("111111111111111111111111111111111111111111111111111111111111111111111111111111111111111");
//System.out.println("type ios "+dto.getQuestionMapperInstance().getQuestionMapper().getQuestion().getQuestionType().getType());
//System.out.println("type ios "+dto.getQuestionMapperInstance().getQuestionMapper().getQuestion().getQuestionText());

%>
	<form:form id="testForm" name="testForm" method="POST" modelAttribute="currentQuestion" enctype="multipart/form-data">
		<header>
			<div class="container-fluid pt-2 pb-2">
				<h1>
					${studentTestForm.testName}
					<div class="text-right company">
						${studentTestForm.emailId} - ${currentQuestion.questionMapperInstance.questionMapper.question.companyName}
					</div>
				</h1>
				<div class="timing">
					<span class="my-auto">	${journeyUTF.timeRemaining}</span>
					<div>
						<input type="text" class="text-center mr-1" id="hours" disabled maxlength="2" value="00">
						<input type="text" class="text-center mr-1" id="min" disabled maxlength="2" value="00">
						<input type="text" class="text-center" id="sec" disabled maxlength="2" value="00">
					</div>
				</div>
			</div>
		</header>
		<section>
			<ul class="section-lists">
				<c:forEach var="sectionInstance" varStatus="status" items="${sectionInstanceDtos}">
					<li ${sectionInstance.style} onclick="javascript:changeSection('${sectionInstance.section.sectionName}');">
						<a href="#">
							${sectionInstance.section.sectionName}
						</a>
					</li>
				</c:forEach>
			</ul>
			<div class="main-content expand">
				<div class="question my-auto mb-2">
					<span class="mr-2">${currentQuestion.position}</span>
					<div style="text-align: right;color:red">
					${journeyUTF.forImageInstruction}
<!-- 					For image/audio/video based Qs, please click the arrow on the right -->
					</div>
					<div>
						${currentQuestion.questionMapperInstance.questionMapper.question.questionText}
						
					</div>
					
				</div>
				<c:choose>
					<c:when test="${currentQuestion.questionMapperInstance.questionMapper.question.type=='MCQ' || currentQuestion.questionMapperInstance.questionMapper.question.type ==null}">
						<div class="mcq mt-3">
							<%
								QuestionInstanceDto currentQuestion = (QuestionInstanceDto) request.getAttribute("currentQuestion");
								System.out.println(currentQuestion.getQuestionMapperInstance().getQuestionMapper().getQuestion().getRightChoices());
								int cc = currentQuestion.getQuestionMapperInstance().getQuestionMapper().getQuestion().getRightChoices().split("-").length;
								if(cc == 1) {
								System.out.println(" cc is "+cc);
							%>
								<div class="custom-control custom-radio mb-2" >
									<form:radiobutton path="radioAnswer" id="one" value="one" class="custom-control-input" />
									<label for="one" class="custom-control-label">${currentQuestion.questionMapperInstance.questionMapper.question.choice1}</label>
								</div>
							<% } else { %>
								<div class="custom-control custom-checkbox mb-2" >
									<form:checkbox path="one" class="custom-control-input" id="check1" />
									<label class="custom-control-label" for="check1">${currentQuestion.questionMapperInstance.questionMapper.question.choice1}</label>
								</div>
							<% } %>

							<% if(cc == 1) { %>
								<div class="custom-control custom-radio mb-2" style="${currentQuestion.questionMapperInstance.questionMapper.question.choice2 == null || 

			currentQuestion.questionMapperInstance.questionMapper.question.choice2.trim().length() == 0? 'display: none;':''}">
									<form:radiobutton id="two" path="radioAnswer" value="two" class="custom-control-input" />
									<label for="two"class="custom-control-label" >${currentQuestion.questionMapperInstance.questionMapper.question.choice2}</label>
								</div>
							<% } else { %>
								<div class="custom-control custom-checkbox mb-2" style="${currentQuestion.questionMapperInstance.questionMapper.question.choice2 == null || 

			currentQuestion.questionMapperInstance.questionMapper.question.choice2.trim().length() == 0? 'display: none;':''}">
									<form:checkbox path="two" class="custom-control-input" id="check2"/>
									<label class="custom-control-label" for="check2">${currentQuestion.questionMapperInstance.questionMapper.question.choice2}</label>
								</div>
							<% } %>

							<% if(cc == 1) { %>
								<div class="custom-control custom-radio mb-2" style="${currentQuestion.questionMapperInstance.questionMapper.question.choice3 == null || 

			currentQuestion.questionMapperInstance.questionMapper.question.choice3.trim().length() == 0? 'display: none;':''}">
									<form:radiobutton path="radioAnswer" value="three" id="three" class="custom-control-input" />
									<label for="three" class="custom-control-label">${currentQuestion.questionMapperInstance.questionMapper.question.choice3}</label>
								</div>
							<% } else { %>
								<div class="custom-control custom-checkbox mb-2" style="${currentQuestion.questionMapperInstance.questionMapper.question.choice3 == null || 

			currentQuestion.questionMapperInstance.questionMapper.question.choice3.trim().length() == 0? 'display: none;':''}">
									<form:checkbox path="three" class="custom-control-input" id="check3"/>
									<label class="custom-control-label" for="check3">${currentQuestion.questionMapperInstance.questionMapper.question.choice3}</label>
								</div>
							<% } %>

							<% if(cc == 1) { %>
								<div class="custom-control custom-radio mb-2" style="${currentQuestion.questionMapperInstance.questionMapper.question.choice4 == null || 

			currentQuestion.questionMapperInstance.questionMapper.question.choice4.trim().length() == 0? 'display: none;':''}">
									<form:radiobutton path="radioAnswer" value="four" id="four" class="custom-control-input" />
									<label for="four" class="custom-control-label">${currentQuestion.questionMapperInstance.questionMapper.question.choice4}</label>
								</div>
							<% } else { %>
								<div class="custom-control custom-checkbox mb-2" style="${currentQuestion.questionMapperInstance.questionMapper.question.choice4 == null || 

			currentQuestion.questionMapperInstance.questionMapper.question.choice4.trim().length() == 0? 'display: none;':''}">
									<form:checkbox path="four" class="custom-control-input" id="check4"/>
									<label class="custom-control-label" for="check4">${currentQuestion.questionMapperInstance.questionMapper.question.choice4}</label>
								</div>
							<% } %>

							<% if(cc == 1) { %>
								<div class="custom-control custom-radio mb-2" style="${currentQuestion.questionMapperInstance.questionMapper.question.choice5 == null || 

			currentQuestion.questionMapperInstance.questionMapper.question.choice5.trim().length() == 0? 'display: none;':''}">
									<form:radiobutton path="radioAnswer" value="five" id="five" class="custom-control-input"/>
									<label for="five" class="custom-control-label">${currentQuestion.questionMapperInstance.questionMapper.question.choice5}</label>
								</div>
							<% } else { %>
								<div class="custom-control custom-checkbox mb-2" style="${currentQuestion.questionMapperInstance.questionMapper.question.choice5 == null || 

			currentQuestion.questionMapperInstance.questionMapper.question.choice5.trim().length() == 0? 'display: none;':''}">
									<form:checkbox path="five" class="custom-control-input" id="check5"/>
									<label class="custom-control-label" for="check5">${currentQuestion.questionMapperInstance.questionMapper.question.choice5}</label>
								</div>
							<% } %>

							<% if(cc == 1) { %>
								<div class="custom-control custom-radio mb-2" style="${currentQuestion.questionMapperInstance.questionMapper.question.choice6 == null || 

			currentQuestion.questionMapperInstance.questionMapper.question.choice6.trim().length() == 0? 'display: none;':''}">
									<form:radiobutton path="radioAnswer" value="six" id="six" class="custom-control-input"/>
									<label for="six" class="custom-control-label">${currentQuestion.questionMapperInstance.questionMapper.question.choice6}</label>
								</div>
							<% } else { %>
								<div class="custom-control custom-checkbox mb-2" style="${currentQuestion.questionMapperInstance.questionMapper.question.choice6 == null || 

			currentQuestion.questionMapperInstance.questionMapper.question.choice6.trim().length() == 0? 'display: none;':''}">
									<form:checkbox path="six" class="custom-control-input" id="check6" />
									<label class="custom-control-label" for="check6">${currentQuestion.questionMapperInstance.questionMapper.question.choice6}</label>
								</div>
							<% } %>

							<c:if test = "${confidenceFlag != null && confidenceFlag == true}">
								<hr class="mt-3 mb-3">
								<div class="confirm">
									<h3 class="mb-2">Are you confident of you answer?</h3>
									<div class="row">
										<div class="col-6">
											<div class="custom-control custom-radio mb-2">
												<form:radiobutton path="confidence" value="yes" id="yes" />
												<label for="yes" class="custom-control-label">Yes</label>
												<form:radiobutton path="confidence" value="yes" id="no" />
												<label for="no" class="custom-control-label">No</label>
											</div>
										</div>
										<div class="col-6">
											<div class="custom-control custom-radio mb-2">
												
											</div>
										</div>
									</div>
								</div>
							</c:if>
						</div>
					</c:when>
					<c:when test="${currentQuestion.questionMapperInstance.questionMapper.question.type=='CODING'}">
						<div class="coding mt-3">
							<div class="headings mb-2">
								${currentQuestion.questionMapperInstance.questionMapper.question.qualifier1} ${currentQuestion.questionMapperInstance.questionMapper.question.qualifier2} ${currentQuestion.questionMapperInstance.questionMapper.question.qualifier3} ${currentQuestion.questionMapperInstance.questionMapper.question.qualifier4} ${currentQuestion.questionMapperInstance.questionMapper.question.qualifier5}
							</div>
							<div class="code-run mb-2">
								<button type="button" class="btn btn-primary" onClick="runCodeSystemTestCase()">
									${journeyUTF.runSystemTestCase}
								</button>
								<button type="button" class="btn btn-primary" onClick="runCode()">
									${journeyUTF.runCode}
								</button>
							</div>
							<div class="headings mb-2">
									${journeyUTF.code}
							</div>
							<div class="mb-2">
								<form:textarea id="editor" path="code" wrap="physical" />
								<form:hidden path="code" id="codeOfEditor" wrap="physical"/>
							</div>
							<div class="headings mb-2">
								${journeyUTF.input}
							</div>
							<div class="mb-2">
								<form:textarea path="input" id="input" class="input" placeholder="Enter input"/>
							</div>
							<div class="headings mb-2">
									${journeyUTF.output}
							</div>
							<div class="mb-2">
								<form:textarea path="output" id="output" disabled="true"/>
							</div>
						</div>
					</c:when>
					<c:when test="${currentQuestion.questionMapperInstance.questionMapper.question.type=='FILL_BLANKS_MCQ'}">
						<div class="fill-blanks mt-3">
							<div class="heading mb-2">
								<% 
									QuestionInstanceDto currentQuestion = (QuestionInstanceDto) request.getAttribute("currentQuestion");
									System.out.println("fill in the blanks "+currentQuestion.getFillInBlanks().size());
								%>
							</div>
							<c:forEach varStatus="s" items="${currentQuestion.fillInBlanks}">
								<div class="fill-up mb-2">
									<form:input path="fillInBlanks[${s.index}]" placeholder="Fill the Blank" />
								</div>
							</c:forEach>
						</div>
					</c:when>
					<c:when test="${currentQuestion.questionMapperInstance.questionMapper.question.type=='MATCH_FOLLOWING_MCQ'}">
						<div class="match-following mt-3">
							<ul class="question">
								<li id="q1">
									${currentQuestion.questionMapperInstance.questionMapper.question.matchLeft1}
								</li>
								<li id="q2">
									${currentQuestion.questionMapperInstance.questionMapper.question.matchLeft2}
								</li>
								<c:if test="${currentQuestion.mtfSize > 2}">
									<li id="q3">${currentQuestion.questionMapperInstance.questionMapper.question.matchLeft3}</li>
								</c:if>
						
								<c:if test="${currentQuestion.mtfSize > 3}">
									<li id="q4">${currentQuestion.questionMapperInstance.questionMapper.question.matchLeft4}</li>
								</c:if>
						
								<c:if test="${currentQuestion.mtfSize > 4}">
									<li id="q5">${currentQuestion.questionMapperInstance.questionMapper.question.matchLeft5}</li>
								</c:if>
						
								<c:if test="${currentQuestion.mtfSize > 5}">
									<li id="q6">${currentQuestion.questionMapperInstance.questionMapper.question.matchLeft6}</li>
								</c:if>
							</ul>
							<ul class="answer">
								<li id="a1">${currentQuestion.mtf.matchRight1Display}</li>
								<form:hidden path="mtf.matchRight1" value="${currentQuestion.mtf.matchRight1}"  />

								<li id="a2">${currentQuestion.mtf.matchRight2Display}</li>
								<form:hidden path="mtf.matchRight2" value="${currentQuestion.mtf.matchRight2}" />

								<c:if test="${currentQuestion.mtfSize > 2}">
									<li id="a3">${currentQuestion.mtf.matchRight3Display}</li>
									<form:hidden path="mtf.matchRight3" value="${currentQuestion.mtf.matchRight3}" />
								</c:if>
								<c:if test="${currentQuestion.mtfSize > 3}">
									<li id="a4">${currentQuestion.mtf.matchRight4Display}</li>
									<form:hidden path="mtf.matchRight4" value="${currentQuestion.mtf.matchRight4}" />
								</c:if>
								<c:if test = "${currentQuestion.mtfSize > 4}">
									<li id="a5">${currentQuestion.mtf.matchRight5Display}</li>
									<form:hidden path="mtf.matchRight5" value="${currentQuestion.mtf.matchRight5}" />
								</c:if>
								<c:if test="${currentQuestion.mtfSize > 5}">
									<li id="a6">${currentQuestion.mtf.matchRight6Display}</li>
									<form:hidden path="mtf.matchRight6" value="${currentQuestion.mtf.matchRight6}" />
								</c:if>
							</ul>
						</div>
					</c:when>
<c:when test="${currentQuestion.questionMapperInstance.questionMapper.question.type=='IMAGE_UPLOAD_BY_USER' || currentQuestion.questionMapperInstance.questionMapper.question.type=='VIDEO_UPLOAD_BY_USER'}">
						<div class="mcq mt-3">
							<div class="formfield">
						<label class="quetestcases">Upload ${currentQuestion.questionMapperInstance.questionMapper.question.type=='IMAGE_UPLOAD_BY_USER'?'Image':'Video'}</label>
                                        
                       <input type="file" name="imageVideoData" id="imageVideoData" > 
					   <form:hidden path = "type" value = "${currentQuestion.questionMapperInstance.questionMapper.question.type}" />
					   
					   <form:hidden path = "questionMapperId" value = "${currentQuestion.questionMapperInstance.questionMapper.id}" />
					   
					  <!--  <form:input type="file" path="imageVideoData" id="imageVideoData" accept="image/*" />-->
						</div>
						
						</div>
					</c:when>
	<c:when test="${currentQuestion.questionMapperInstance.questionMapper.question.type=='SUBJECTIVE_TEXT'}">
					
						<div >
							
						<label > Answer the question</label><br/>
                               <form:textarea path="questionMapperInstance.subjectiveText" rows="7" cols="30" />         
                        
						</div>
						
						</div>
					</c:when>
					
				</c:choose>
				<div class="assessment-progress mt-3 pt-2 pb-2">
					<div class="mb-2">
						<div class="progress mb-2">
							<div class="progress-bar progress-bar-striped" role="progressbar" style="width: ${percentage}%" aria-valuenow="${percentage}" aria-valuemin="0" aria-valuemax="100"></div>
						</div>
						${noAnswered} / ${totalQuestions} ${journeyUTF.questionCompleted}
					</div>
					<div class="mb-2 text-right">
						<c:choose>
							<c:when test="${currentSection.first==true}"></c:when>
							<c:otherwise>
								<button type="button" class="btn btn-secondary float-left" onClick="prev()">
								${journeyUTF.prev}
								</button>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${currentSection.last==true}">
								<button id="next" type="button" class="btn btn-primary" onClick="submitTestCheckNoAnswer();" >
								${journeyUTF.submit}
								</button>
							</c:when>
							<c:otherwise>
								<button id="next" type="button" class="btn btn-primary" onClick="eerrtt()">
								${journeyUTF.next}
								</button>
							</c:otherwise>
						</c:choose>		
					</div>
				</div>
			</div>
			<div class="descriptions hidden">
				<button type="button" class="des-toggler my-auto">
					<i class="material-icons">
						keyboard_arrow_left
					</i>
				</button>
				<div class="description-content">
					<h3>${journeyUTF.discription}</h3>
					<p>
<%-- 					${(currentQuestion.questionMapperInstance.questionMapper.question.instructionsIfAny==null || currentQuestion.questionMapperInstance.questionMapper.question.instructionsIfAny.trim().length()== 0)?"<p>&#8226; Do not move mouse pointer to a different tab  </p><p>&#8226; ${journeyUTF.discription2}   </p><p>&#8226; ${journeyUTF.discription3}   </p>":currentQuestion.questionMapperInstance.questionMapper.question.instructionsIfAny}</p> --%>
					<c:choose>
					<c:when test="${(currentQuestion.questionMapperInstance.questionMapper.question.instructionsIfAny==null || currentQuestion.questionMapperInstance.questionMapper.question.instructionsIfAny.trim().length()== 0)}">
						<p>&#8226; ${journeyUTF.discription1}   </p><p>&#8226; ${journeyUTF.discription2}   </p><p>&#8226; ${journeyUTF.discription3}   </p>
					</c:when>
					<c:otherwise>
							${currentQuestion.questionMapperInstance.questionMapper.question.instructionsIfAny}
					</c:otherwise>
					</c:choose>
					<c:if test="${currentQuestion.questionMapperInstance.questionMapper.question.imageUrl != null && currentQuestion.questionMapperInstance.questionMapper.question.imageUrl.trim().length() > 0}">
						<img src="${currentQuestion.questionMapperInstance.questionMapper.question.imageUrl}">
					</c:if>

					<c:if test="${currentQuestion.questionMapperInstance.questionMapper.question.audioURL != null && currentQuestion.questionMapperInstance.questionMapper.question.audioURL.trim().length() > 0}">
						<audio controls src="${currentQuestion.questionMapperInstance.questionMapper.question.audioURL}">
							Your browser does not support the <code>audio</code> element.
						</audio>
					</c:if>

					<c:if test="${currentQuestion.questionMapperInstance.questionMapper.question.videoURL != null && currentQuestion.questionMapperInstance.questionMapper.question.videoURL.trim().length() > 0}">
						<video controls>
							<source src="${currentQuestion.questionMapperInstance.questionMapper.question.videoURL}" > 
							Your browser does not support the video tag.
						</video>
					</c:if>
						
					<c:if test="${currentQuestion.questionMapperInstance.questionMapper.question.type=='CODING'}">
						<code>
							Update code in Code Editor 
						</code>
						
						<h4>Constraint</h4>
						<p>${currentQuestion.questionMapperInstance.questionMapper.question.constrnt}</p>

						<h4>Example Input</h4>
						<code>
							${currentQuestion.questionMapperInstance.questionMapper.question.hiddenInputPositive}
						</code>

						<h4>Expected Output</h4>
						<code>
							${currentQuestion.questionMapperInstance.questionMapper.question.hiddenOutputPositive}
						</code>
					</c:if>
				</div>
			</div>
		</section>
		<footer>
			<div class="container-fluid pt-3 pb-3">
				<span>
					&copy; Copyright 2020 :: eAssess 
				</span>
				<a href="javascript:void(0)" class="mr-5">
					Terms and Conditions
				</a>
				<a href="javascript:void(0)">
					Privacy Policy
				</a>
			</div>
		</footer>
	</form:form>
</body>

<script>
	var randomNumber = Math.floor(Math.random() * (6 - 1 + 1)) + 1;
	$('header').attr('style', "background-image: url(images_new/banner_" + randomNumber + ".jpg);");

	$('.des-toggler').on('click', function () {
		var parent = $(this).closest('.descriptions');
		if(parent.hasClass('hidden')) {
			parent.removeClass('hidden');
			$('.main-content').removeClass('expand');
		} else {
			parent.addClass('hidden');
			$('.main-content').addClass('expand');
		}
		
		// var $this = $(this),
		// 	attr = $this.closest('.descriptions').attr('style');

		// if (typeof attr !== typeof undefined && attr !== false) {
		// 	$this.find('i').html('keyboard_arrow_right');
		// 	$this.closest('.descriptions').find('.des-content').show();
		// 	$this.closest('.descriptions').removeAttr('style');
		// 	$this.removeAttr('style');
		// 	$('.session-content').removeAttr('style');
		// } else {
		// 	$this.find('i').html('keyboard_arrow_left');
		// 	$this.closest('.descriptions').find('.des-content').hide();
		// 	$this.closest('.descriptions').attr('style', 'width:0px; margin-left:100%; padding: 0');
		// 	$this.attr('style', 'left: -40px');
		// 	$('.session-content').attr('style', 'width: 95%');
		// }
	});

	var editor = ace.edit("editor");
	editor.setTheme("ace/theme/tomorrow_night_blue");
	//editor.setTheme("ace/theme/mono_industrial");
	
	var language = '${currentQuestion.questionMapperInstance.questionMapper.question.language.language}';
	if(language == 'JAVA'){
		editor.session.setMode("ace/mode/java");
	}
	else if(language == 'C'){
		editor.session.setMode("ace/mode/c_cpp");
	}
	else if(language == 'C++'){
		editor.session.setMode("ace/mode/c_cpp");
	}
	else if(language == 'C#'){
		editor.session.setMode("ace/mode/csharp");
	}
	else if(language == 'PYTHON'){
		editor.session.setMode("ace/mode/python");
	}
	else if(language == 'PHP'){
		editor.session.setMode("ace/mode/php");
		
	}
	else if(language == 'JAVASCRIPT'){
		editor.session.setMode("ace/mode/javascript");
	}
	else if(language == 'CLOJURE'){
		editor.session.setMode("ace/mode/clojure");
	}
	else if(language == 'GO'){
		editor.session.setMode("ace/mode/golang");
	}
	else if(language == 'BASH'){
		editor.session.setMode("ace/mode/batchfile");
	}
	else if(language == 'OBJECTIVE_C'){
		editor.session.setMode("ace/mode/objectivec");
	}
	else if(language == 'MYSQL'){
		editor.session.setMode("ace/mode/sql");
	}
	else if(language == 'PERL'){
		editor.session.setMode("ace/mode/perl");
	}
	else if(language == 'RUST'){
		editor.session.setMode("ace/mode/rust");
	}
	
	
	
	editor.setValue('${currentQuestion.code}');
	editor.setOptions({
	enableBasicAutocompletion: true, // the editor completes the statement when you hit Ctrl + Space
	enableLiveAutocompletion: true, // the editor completes the statement while you are typing
	showPrintMargin: false, // hides the vertical limiting strip
	maxLines: Infinity,
	fontSize: "100%" // ensures that the editor fits in the environment
});

</script>
<script>
	var questionColor = '';
	$(document).ready(function(){
		$('.question li').click(function(){
			questionColor = $(this).css("background-color");
			$('.question li').removeAttr('style');
			$(this).css('box-shadow', '0 0 10px 3px rgba(0,0,0,0.4)');
		});
		$('.answer li').click(function(){
			$(".answer li").each(function( i ) {
				if($(this).css("background-color") == questionColor){
					$(this).removeAttr('style');
				}
			});
			$(this).css('background-color', questionColor);
		});
		
		var a1 = document.getElementById("a1");
		console.log(' in load ');
		if(a1 != null){
			
			var col1 = '<c:out value="${currentQuestion.mtf.matchRight1DisplayColour}"/>';
			console.log(' in load col1 '+col1);
			if(col1 != null){
				console.log(' in load col1 set'+col1);
				a1.style.backgroundColor = col1;
				console.log(' in load col1 set done'+col1);
			}
			
		}
		
		var a2 = document.getElementById("a2");
		if(a2 != null){
			var col2 = '<c:out value="${currentQuestion.mtf.matchRight2DisplayColour}"/>';
			if(col2 != null){
				a2.style.backgroundColor = col2;
			}
			
		}
		
		var a3 = document.getElementById("a3");
		if(a3 != null){
			var col3 = '<c:out value="${currentQuestion.mtf.matchRight3DisplayColour}"/>';
			if(col3 != null){
				a3.style.backgroundColor = col3;
			}
			
		}
		
		var a4 = document.getElementById("a4");
		if(a4 != null){
			var col4 = '<c:out value="${currentQuestion.mtf.matchRight4DisplayColour}"/>';
			if(col4 != null){
				a4.style.backgroundColor = col4;
			}
			
		}
		
		var a5 = document.getElementById("a5");
		if(a5 != null){
			var col5 = '<c:out value="${currentQuestion.mtf.matchRight5DisplayColour}"/>';
			if(col5 != null){
				a5.style.backgroundColor = col5;
			}
			
		}
		
		var a6 = document.getElementById("a6");
		if(a6 != null){
			var col6 = '<c:out value="${currentQuestion.mtf.matchRight6DisplayColour}"/>';
			if(col6 != null){
				a6.style.backgroundColor = col6;
			}
			
		}
		
		
	});
	
	
	


function setMtfValues(qType){
	if(qType == 'MATCH_FOLLOWING_MCQ'){
	
	
	var cola1 = document.getElementById("a1").style.backgroundColor;
	var cola2 = document.getElementById("a2").style.backgroundColor;
	var cola3 = null;
		if(document.getElementById("a3") != null){
			cola3 = document.getElementById("a3").style.backgroundColor;
		}
	
	var cola4 = null;
		if(document.getElementById("a4") != null){
			cola4 = document.getElementById("a4").style.backgroundColor;
		}
		
	var cola5 = null;
		if(document.getElementById("a5") != null){
			cola5 = document.getElementById("a5").style.backgroundColor;
		}
	
	var cola6 = null;
		if(document.getElementById("a6") != null){
			cola6 = document.getElementById("a6").style.backgroundColor;
		}
		
		if(cola1 != null && cola1 == "rgb(255, 0, 0)"){
			document.getElementById("mtf.matchRight1").value = document.getElementById("a1").innerHTML;
		}
		else if(cola2 != null && cola2 == "rgb(255, 0, 0)"){
			document.getElementById("mtf.matchRight1").value = document.getElementById("a2").innerHTML;
		}
		else if(cola3 != null && cola3 == "rgb(255, 0, 0)"){
			document.getElementById("mtf.matchRight1").value = document.getElementById("a3").innerHTML;
		}
		else if(cola4 != null && cola4 == "rgb(255, 0, 0)"){
			var a1val = document.getElementById("a4").innerHTML;
			document.getElementById("mtf.matchRight1").value = a1val;
			console.log(' val '+document.getElementById("mtf.matchRight4").value);
			console.log(' a1 '+a1val);
		}
		else if(cola5 != null && cola5 == "rgb(255, 0, 0)"){
			document.getElementById("mtf.matchRight1").value = document.getElementById("a5").innerHTML;
		}
		else if(cola6 != null && cola6 == "rgb(255, 0, 0)"){
			document.getElementById("mtf.matchRight1").value = document.getElementById("a6").innerHTML;
		}
		
		if(cola1!= null && cola1 == "rgb(0, 128, 0)"){
			document.getElementById("mtf.matchRight2").value = document.getElementById("a1").innerHTML;
		}
		else if(cola2!= null && cola2 == "rgb(0, 128, 0)"){
			document.getElementById("mtf.matchRight2").value = document.getElementById("a2").innerHTML;
		}
		else if(cola3!= null && cola3 == "rgb(0, 128, 0)"){
			document.getElementById("mtf.matchRight2").value = document.getElementById("a3").innerHTML;
		}
		else if(cola4!= null && cola4 == "rgb(0, 128, 0)"){
			document.getElementById("mtf.matchRight2").value = document.getElementById("a4").innerHTML;
		}
		else if(cola5!= null && cola5 == "rgb(0, 128, 0)"){
			document.getElementById("mtf.matchRight2").value = document.getElementById("a5").innerHTML;
		}
		else if(cola6!= null && cola6 == "rgb(0, 128, 0)"){
			document.getElementById("mtf.matchRight2").value = document.getElementById("a6").innerHTML;
		}
		
		if(cola1 != null && cola1 == "rgb(0, 0, 255)"){
			document.getElementById("mtf.matchRight3").value = document.getElementById("a1").innerHTML;
		}
		else if(cola2 != null && cola2 == "rgb(0, 0, 255)"){
			document.getElementById("mtf.matchRight3").value = document.getElementById("a2").innerHTML;
		}
		else if(cola3 != null && cola3 == "rgb(0, 0, 255)"){
			document.getElementById("mtf.matchRight3").value = document.getElementById("a3").innerHTML;
		}
		else if(cola4 != null && cola4 == "rgb(0, 0, 255)"){
			document.getElementById("mtf.matchRight3").value = document.getElementById("a4").innerHTML;
		}
		else if(cola5 != null && cola5 == "rgb(0, 0, 255)"){
			document.getElementById("mtf.matchRight3").value = document.getElementById("a5").innerHTML;
		}
		else if(cola6 != null && cola6 == "rgb(0, 0, 255)"){
			document.getElementById("mtf.matchRight3").value = document.getElementById("a6").innerHTML;
		}
		
		if(cola1 != null && cola1 == "rgb(255, 192, 203)"){
			document.getElementById("mtf.matchRight4").value = document.getElementById("a1").innerHTML;
		}
		else if(cola2 != null && cola2 == "rgb(255, 192, 203)"){
			document.getElementById("mtf.matchRight4").value = document.getElementById("a2").innerHTML;
		}
		else if(cola3 != null && cola3 == "rgb(255, 192, 203)"){
			document.getElementById("mtf.matchRight4").value = document.getElementById("a3").innerHTML;
		}
		else if(cola4 != null && cola4 == "rgb(255, 192, 203)"){
			document.getElementById("mtf.matchRight4").value = document.getElementById("a4").innerHTML;
		}
		else if(cola5 != null && cola5 == "rgb(255, 192, 203)"){
			document.getElementById("mtf.matchRight4").value = document.getElementById("a5").innerHTML;
		}
		else if(cola6 != null && cola6 == "rgb(255, 192, 203)"){
			document.getElementById("mtf.matchRight4").value = document.getElementById("a6").innerHTML;
		}
		
		if(cola1 != null && cola1 == "rgb(235, 21, 135)"){
			document.getElementById("mtf.matchRight5").value = document.getElementById("a1").innerHTML;
		}
		else if(cola2 != null && cola2 == "rgb(235, 21, 135)"){
			document.getElementById("mtf.matchRight5").value = document.getElementById("a2").innerHTML;
		}
		else if(cola3 != null && cola3 == "rgb(235, 21, 135)"){
			document.getElementById("mtf.matchRight5").value = document.getElementById("a3").innerHTML;
		}
		else if(cola4 != null && cola4 == "rgb(235, 21, 135)"){
			document.getElementById("mtf.matchRight5").value = document.getElementById("a4").innerHTML;
		}
		else if(cola5 != null && cola5 == "rgb(235, 21, 135)"){
			document.getElementById("mtf.matchRight5").value = document.getElementById("a5").innerHTML;
		}
		else if(cola6 != null && cola6 == "rgb(235, 21, 135)"){
			document.getElementById("mtf.matchRight5").value = document.getElementById("a6").innerHTML;
		}
		
		if(cola1 != null && cola1 == "rgb(186, 252, 53)"){
			document.getElementById("mtf.matchRight6").value = document.getElementById("a1").innerHTML;
		}
		else if(cola2 != null && cola2 == "rgb(186, 252, 53)"){
			document.getElementById("mtf.matchRight6").value = document.getElementById("a2").innerHTML;
		}
		else if(cola3 != null && cola3 == "rgb(186, 252, 53)"){
			document.getElementById("mtf.matchRight6").value = document.getElementById("a3").innerHTML;
		}
		else if(cola4 != null && cola4 == "rgb(186, 252, 53)"){
			document.getElementById("mtf.matchRight6").value = document.getElementById("a4").innerHTML;
		}
		else if(cola5 != null && cola5 == "rgb(186, 252, 53)"){
			document.getElementById("mtf.matchRight6").value = document.getElementById("a5").innerHTML;
		}
		else if(cola6 != null && cola6 == "rgb(186, 252, 53)"){
			document.getElementById("mtf.matchRight6").value = document.getElementById("a6").innerHTML;
		}
	
	}
}
</script>

	
<script>
$(function () {
			$(".addimage").on('click', function (e) {
				e.preventDefault();
				$("#addimage").trigger('click');
			});
			
		});

	$('#addimage').change(function () {
			var file = $('#addimage')[0].files[0].name;
			$('.queimage').text('Document to upload: '+file);
			uploadProjectDocs();
		});

function changeSection(sectionName){
	//window.location = 'changeSection?sectionName='+sectionName+"&timeCounter="+timeCounter;
	//localStorage.setItem('timeCounter', timeCounter);
	var tp = '${currentQuestion.questionMapperInstance.questionMapper.question.type}';
		if(tp == 'CODING'){
			confirm(sectionName);
		}
		else{
			window.location = 'changeSection?sectionName='+sectionName+"&timeCounter="+timeCounter;
			localStorage.setItem('timeCounter', timeCounter);
		}
	
}

function get_center_pos(width, top){
// top is empty when creating a new notification and is set when recentering
	if (!top){
		top = 30;
		// this part is needed to avoid notification stacking on top of each other
		$('.ui-pnotify').each(function() { top += $(this).outerHeight() + 20; });
	}

	return {"top": top, "left": ($(window).width() / 2) - (width / 2)}
}

function confirm(sectionName) {
		(new PNotify({
		title: 'Confirmation Needed',
		text: 'For a coding Question if you change a section you may loose your changes. Either copy your code somewhere and then change section or use Next/Back to navigate',
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
		},
			before_open: function (PNotify) {
		PNotify.get().css(get_center_pos(PNotify.get().width()));
		}
	})).get().on('pnotify.confirm', function() {
		window.location = 'changeSection?sectionName='+sectionName+"&timeCounter="+timeCounter;
		localStorage.setItem('timeCounter', timeCounter);
	}).on('pnotify.cancel', function() {
		
	});
}

function runCode(){
//editor
//var editor = ace.edit("editor");
var code = editor.getValue();
var input = document.getElementById('input').value;
var lang = '8';
var language = '${currentQuestion.questionMapperInstance.questionMapper.question.language.language}';
	if(language == 'JAVA'){
		lang = '8';
	}
	else if(language == 'C'){
		lang = '7';
	}
	else if(language == 'CPLUSPLUS'){
		lang = '7';
	}
	else if(language == 'CHASH'){
		lang = '10';
	}
	else if(language == 'DotNet'){
		lang = '10';
	}
	else if(language == 'PYTHON'){
		lang = '0';
	}
	else if(language == 'PHP'){
		lang = '3';
	}
	else if(language == 'JAVASCRIPT'){
		lang = '4';
	}
	else if(language == 'CLOJURE'){
		lang = '2';
	}
	else if(language == 'GO'){
		lang = '6';
	}
	else if(language == 'BASH'){
		lang = '11';
	}
	else if(language == 'OBJECTIVE_C'){
		lang = '12';
	}
	else if(language == 'MYSQL'){
		lang = '13';
	}
	else if(language == 'PERL'){
		lang = '14';
	}
	else if(language == 'RUST'){
		lang = '15';
	}

var url = 'compile';
var data = {}; 
data.language = lang;
data.code = code;
data.stdin = input;
//var json = "{language:"+lang+", code:"+code+", stdin:"+input+"}";
document.getElementById('output').value = 'Executing your code...';	
document.getElementById("output").focus();
document.getElementById("output").scrollIntoView();
dta = JSON.stringify(data);
//dta = dta.slice(1,-1);
//dat = "'"+dta+"'";
	$.ajax({
			type : 'POST',
			url : url,
			contentType: "application/json; charset=utf-8",
			data: dta,
			success : function(data) {
				
				document.getElementById('output').value = data;
				//document.getElementById('output').value = 'eee';
				console.log("SUCCESS: ", data);
			},
			error : function(e) {
				console.log("ERROR: ", e);
				
			}
		});
}

function runCodeSystemTestCase(){
	//var editor = ace.edit("editor");
var code = editor.getValue();
var input = "${currentQuestion.questionMapperInstance.questionMapper.question.hiddenInputPositive}";
document.getElementById('input').value = input;
var lang = '8';
var language = '${currentQuestion.questionMapperInstance.questionMapper.question.language.language}';
	if(language == 'JAVA'){
		lang = '8';
	}
	else if(language == 'C'){
		lang = '7';
	}
	else if(language == 'CPLUSPLUS'){
		lang = '7';
	}
	else if(language == 'CHASH'){
		lang = '10';
	}
	else if(language == 'DotNet'){
		lang = '10';
	}
	else if(language == 'PYTHON'){
		lang = '0';
	}
	else if(language == 'PHP'){
		lang = '3';
	}
	else if(language == 'JAVASCRIPT'){
		lang = '4';
	}
	else if(language == 'CLOJURE'){
		lang = '2';
	}
	else if(language == 'GO'){
		lang = '6';
	}
	else if(language == 'BASH'){
		lang = '11';
	}
	else if(language == 'OBJECTIVE_C'){
		lang = '12';
	}
	else if(language == 'MYSQL'){
		lang = '13';
	}
	else if(language == 'PERL'){
		lang = '14';
	}
	else if(language == 'RUST'){
		lang = '15';
	}

var url = 'compileAndRunSystemTest';

var data = {}; 
data.language = lang;
data.code = code;
data.stdin = input;
document.getElementById('output').value = 'Executing your code...';	
document.getElementById("output").focus();
document.getElementById("output").scrollIntoView();
dta = JSON.stringify(data);

	$.ajax({
			type : 'POST',
			url : url,
			contentType: "application/json; charset=utf-8",
			data: dta,
			success : function(data) {
				console.log("SUCCESS: ", data);
				//document.getElementById('output').value = data;
				if(data == "${currentQuestion.questionMapperInstance.questionMapper.question.hiddenOutputPositive}"){
					document.getElementById('output').value = (data + '\n' +'SUCCESS');
				}
				else{
				document.getElementById('output').value = (data + '\n' +'FAILED');
				}
				
			},
			error : function(e) {
				console.log("ERROR: ", e);
				
			}
		});
}




function prev(){
var qType = '${currentQuestion.questionMapperInstance.questionMapper.question.type}';
//var qType = '${currentQuestion.questionMapperInstance.questionMapper.question.type}';
	if(qType == 'MCQ'){
		var one = $( 'input[name="one"]:checked' ).val();
		var two = $( 'input[name="two"]:checked' ).val();
		var three = $( 'input[name="three"]:checked' ).val();
		var four = $( 'input[name="four"]:checked' ).val();
		var five = $( 'input[name="five"]:checked' ).val();
		var six = $( 'input[name="six"]:checked' ).val();
		count = 0;
		if(one != null){
			count ++;
		}
		
		if(two != null){
			count ++;
		}
		
		if(three != null){
			count ++;
		}
		
		if(four != null){
			count ++;
		}
		
		if(five != null){
			count ++;
		}
		if(six != null){
			count ++;
		}
		
		var correctNo = ('${currentQuestion.questionMapperInstance.questionMapper.question.rightChoices}'.match(/-/g) || []).length  + 1;
		

		console.log('${currentQuestion.questionMapperInstance.questionMapper.question.rightChoices}');
		console.log('correct choices'+correctNo);
		console.log('no of chosen choices'+count);
		if(count == correctNo){
			//notify('INFO', 'go ahead');
		}
		else{
			//do nothing cognizant
		//notify('INFO', 'No of Answers chosen are not equal to no of correct answers. Please select '+correctNo+' option(s)');
		//return;
		}
		
		
	}

if(qType == 'CODING'){
	var textarea = document.getElementById('codeOfEditor');
	edt = editor.getSession().getValue();
	textarea.value = edt;
}

setMtfValues(qType);

document.testForm.action = "prevQuestion?questionId=${currentQuestion.questionMapperInstance.questionMapper.id}&timeCounter="+timeCounter;
storeTimeLocal();
document.testForm.submit();
}

function submitTest(){
var qType = '${currentQuestion.questionMapperInstance.questionMapper.question.type}';
//	var qType = '${currentQuestion.questionMapperInstance.questionMapper.question.type}';
	if(qType == 'MCQ'){
		var one = $( 'input[name="one"]:checked' ).val();
		var two = $( 'input[name="two"]:checked' ).val();
		var three = $( 'input[name="three"]:checked' ).val();
		var four = $( 'input[name="four"]:checked' ).val();
		var five = $( 'input[name="five"]:checked' ).val();
		var six = $( 'input[name="six"]:checked' ).val();
		count = 0;
		if(one != null){
			count ++;
		}
		
		if(two != null){
			count ++;
		}
		
		if(three != null){
			count ++;
		}
		
		if(four != null){
			count ++;
		}
		
		if(five != null){
			count ++;
		}
		if(six != null){
			count ++;
		}
		
		var correctNo = ('${currentQuestion.questionMapperInstance.questionMapper.question.rightChoices}'.match(/-/g) || []).length  + 1;
		

		console.log('${currentQuestion.questionMapperInstance.questionMapper.question.rightChoices}');
		console.log('correct choices'+correctNo);
		console.log('no of chosen choices'+count);
		if(count == correctNo){
			//notify('INFO', 'go ahead');
		}
		else{
		//notify('INFO', 'No of Answers chosen are not equal to no of correct answers. Please select '+correctNo+' option(s)');
		//return;
		}
		
		
	}
	
if(qType == 'CODING'){
	var textarea = document.getElementById('codeOfEditor');
	edt = editor.getSession().getValue();
	textarea.value = edt;
}
//var textarea = document.getElementById('codeOfEditor');
//edt = editor.getSession().getValue();
//textarea.value = edt;
document.testForm.action = "submitTest?questionId=${currentQuestion.questionMapperInstance.questionMapper.id}&timeCounter="+timeCounter;
resetTimeLocal();
//modal.style.display = "block";
//document.getElementById("showAlert").innerHTML = 'You have exceeded your time limit to complete the test. The test will auto submit in a moment...';
document.testForm.submit();
submitTest = 'true';
notify('Info', 'The test is now submitted! Do not click the Submit button again incase you do not get a result screen fast because of a slow connection. DO NOT REFRESH THE PAGE.');
//next
var a = document.getElementById('next');
a.href = "javascript:donothing();";
}

function donothing(){
	notify('Information', 'Your test is already getting submitted. Please Do not click on Submit button again');
}

function storeTimeLocal(){
localStorage.setItem('${studentTestForm.firstName}${studentTestForm.lastName}', 'yes');
localStorage.setItem('testName-${studentTestForm.firstName}${studentTestForm.lastName}', '${studentTestForm.firstName}${studentTestForm.lastName}-'+

'${studentTestForm.testName}');
localStorage.setItem('timeCounter-${studentTestForm.firstName}${studentTestForm.lastName}', timeCounter);
}

function resetTimeLocal(){
localStorage.setItem('${studentTestForm.firstName}${studentTestForm.lastName}', 'no');
localStorage.setItem('testName-${studentTestForm.firstName}${studentTestForm.lastName}', null);
localStorage.setItem('timeCounter-${studentTestForm.firstName}${studentTestForm.lastName}', 0);
}

function submitTestCheckNoAnswer(){
var uanswered = '${totalQuestions - (noAnswered+1)}';
	if(uanswered == '0'){
		notify('Information', 'DO NOT REFRESH the page post submission');
		submitTest();
	}
	else{
		(new PNotify({
		title: 'Confirmation Needed',
		text: 'Are you sure you want to submit the test? You still have unanswered Questions? In the event of you submitting please DO NOT REFESH THE PAGE post submission',
		icon: 'glyphicon glyphicon-question-sign',
		hide: false,
		confirm: {
		confirm: true
		},
		buttons: {
		closer: true,
		sticker: true
		},
		history: {
		history: false
		}
	})).get().on('pnotify.confirm', function() {
		// parent.closeFullScreen();	//uncomment it later
		submitTest();
	}).on('pnotify.cancel', function() {
		
	});
		
	}
	
}

function confirmWorkspace(qMapperInstanceId){
	(new PNotify({
		title: 'Confirmation Needed',
		text: 'Are you sure you have uploaded the project documentation. Your reviewer may take a dim view of your efforts if no documentation is found? If yes you can submit the workspace?',
		icon: 'glyphicon glyphicon-question-sign',
		hide: false,
		confirm: {
		confirm: true
		},
		buttons: {
		closer: true,
		sticker: true
		},
		history: {
		history: false
		}
	})).get().on('pnotify.confirm', function() {
		submitFullStackCode(qMapperInstanceId);
	}).on('pnotify.cancel', function() {
		
	});
}

function showAndNavigate(){
	(new PNotify({
		title: 'About this',
		text: 'Yes to this will download a Project Documentation template that you are expected to update and then upload. Kindly make sure the How-to use part is crystal clear for your reviewer to gro through and start your app. Do you want to proceed now?',
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
		window.open('http://159.65.148.176/file-server/assessment/docs/Project_ReadMe.docx', '_blank');
	}).on('pnotify.cancel', function() {
		
	});
}


function submitFullStackCode(qMapperInstanceId){
	
	
	
	var url = 'submitFullStackCode?qMapperInstanceId='+qMapperInstanceId;

var data = {}; 


	$.ajax({
			type : 'GET',
			url : url,
			contentType: "application/json; charset=utf-8",
			data: data,
			success : function(data) {
				console.log("SUCCESS: ", data);
				notify('Information', data);
				
			},
			error : function(e) {
				console.log("ERROR: ", e);
				
			}
		});
}

function uploadProjectDocs(){
	qMapperInstanceId = '${currentQuestion.questionMapperInstance.id}';
		var formData = new FormData();
		var file = $('#addimage')[0].files[0];
		console.log('1 file is '+file);
		if(file != null){
		formData.append('addimage', file);
		console.log("form data " + formData);
		$.ajax({
			url : 'uploadProjectDocs?qMapperInstanceId='+qMapperInstanceId,
			enctype: 'multipart/form-data',
			data : formData,
			processData : false,
			contentType : false,
			type : 'POST',
			success : function(data) {
					notify('Information','Your file has been uploaded. Check this link <br\>-<a href="'+data+'" >Click here</a> ');
			},
			error : function(err) {
				notify('Information',err);
			}
		});
		}
		else{
			notify('Information', 'Kindly upload the Project Documentations word file');
		}
		
}

</script>

<script>

	function eerrtt(){
		//$('input[name="one"]').not(':checked').val(0);
		var qType = '${currentQuestion.questionMapperInstance.questionMapper.question.type}';
		if(qType == 'MCQ'){
			var one = $( 'input[name="one"]:checked' ).val();
			var two = $( 'input[name="two"]:checked' ).val();
			var three = $( 'input[name="three"]:checked' ).val();
			var four = $( 'input[name="four"]:checked' ).val();
			var five = $( 'input[name="five"]:checked' ).val();
			var six = $( 'input[name="six"]:checked' ).val();
			count = 0;
			if(one != null){
				count ++;
			}
			
			if(two != null){
				count ++;
			}
			
			if(three != null){
				count ++;
			}
			
			if(four != null){
				count ++;
			}
			
			if(five != null){
				count ++;
			}
			if(six != null){
				count ++;
			}
			
			var noOfConfiguredChoices = '${currentQuestion.questionMapperInstance.questionMapper.question.rightChoices}'.split(',').length;
			var correctNo = ('${currentQuestion.questionMapperInstance.questionMapper.question.rightChoices}'.match(/-/g) || []).length  + 1;
			

			//console.log('${currentQuestion.questionMapperInstance.questionMapper.question.rightChoices}');
			//console.log('correct choices'+correctNo);
			//console.log('no of chosen choices'+count);
			if(count == correctNo){
				//notify('INFO', 'go ahead');
			}
			else{
				//do nothing
			//notify('INFO', 'No of Answers chosen are not equal to no of correct answers. Please select '+correctNo+' option(s)');
			//return;
			}
			
			
		}
		
	
	if(qType == 'CODING'){
		var textarea = document.getElementById('codeOfEditor');
		edt = editor.getSession().getValue();
		textarea.value = edt;
	}
	
	setMtfValues(qType);
	
//edt.value = editor.getSession().getValue();
	var linktext=document.getElementById('next').text;
		if(linktext == 'Finish Test'){
		submitTest();
		}
		else{
		document.testForm.action = "nextQuestion?questionId=${currentQuestion.questionMapperInstance.questionMapper.id}&timeCounter="+timeCounter;
		storeTimeLocal();
		document.testForm.submit();
		}

	}
	
	
	

	
	function notify(messageType, message){
		var notification = 'Information';
		//PNotify.prototype.options.styling = "jqueryui";
			$(function(){
				new PNotify({
				title: notification,
				text: message,
				type: messageType,
				width: '60%',
				hide: false,
				buttons: {
						closer: true,
						sticker: false
						},
				history: {
						history: false
					}
			});
				
			}); 	
	}


	$(document).ready(function () {
			//Disable cut copy paste
			$('body').bind('cut copy paste', function (e) {
				e.preventDefault();
			});

			//Disable mouse right click
			$("body").on("contextmenu",function(e){
				return false;
			});
			
				function disablePrev() { window.history.forward() }
				window.onload = disablePrev();
				window.onpageshow = function(evt) { if (evt.persisted) disableBack() 
			}
	});
</script>
	<script src="scripts/src-min-noconflict/ace.js" type="text/javascript" charset="utf-8"></script>
</html>