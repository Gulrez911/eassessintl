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
      	<link href="images/E-assess_E.png" rel="shortcut icon">           
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
        <link href="css/font-awesome.css" rel="stylesheet" type="text/css">
        <link href="css/style.css" rel="stylesheet" type="text/css">
        <link href="css/responsive.css" rel="stylesheet" type="text/css">
	<link href="css/pnotify.custom.min.css" rel="stylesheet" type="text/css">
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="scripts/pnotify.custom.min.js"></script>
	<script type="text/javascript" src="scripts/custom.js"></script>
	
	 <link href="css/font-awesome.css" rel="stylesheet" type="text/css">
    </head>

    <body>

        <div class="maincontainer">            

            <div class="wrapper">
                <div class="row row-offcanvas row-offcanvas-left">
                    <!-- sidebar -->
		   <jsp:include page="side.jsp" /> 
                 
                    <!-- /sidebar -->

                   <div class="column col-sm-10 col-xs-11" id="main">
                        <div class="rightside">
                            <div class="topmenu text-right">
                                <a class="add_test" href="addSkill">Add New</a>
                               
				<a href="signoff">Sign Off</a>
                               
                               
                            </div>
                            <div class="questiontable">
                                <div class="questionheading">
                                    <div class="left">
                                        <h3>Skills Repository</h3>
                                    </div>
                                    <div class="right">
                                        <div class="searchdata">
                                            
					     <input type="text" placeholder="Search a skill" name="searchText" id="searchText">
                                            <i class="fa fa-search" id="search"></i>
                                        </div>
                                       
                                    </div>
                                </div>
                                <div class="questiontablelist" style="overflow-x:auto;">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                               <th>Serial </th>
                                                <th><img src="images/icon-selectionmode.png">Skill Name</th>
                                                
                                                <th>Skill Level</th>
                                               
												<!--<th>Update Skill</th> -->
                                            </tr>
                                        </thead>
                                         <tbody>
					<tbody>
						                     
						                       <c:forEach  items="${skills}" var="skill" varStatus="loop">   
						                      	<tr>
										
													<td>${loop.count}  </td>
						                      		<td>${skill.skillName}  </td>
										
						                      		<td> ${skill.level}</td>
										
						                      	
													<!-- <td> <a  href="addSkill?skillId=${skill.id}">Click to Update</a>  </td> -->
								
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
