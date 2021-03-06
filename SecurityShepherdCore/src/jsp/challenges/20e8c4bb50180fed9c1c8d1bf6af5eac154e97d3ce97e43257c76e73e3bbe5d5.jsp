<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="utils.*" errorPage="" %>
<%
/**
 * <br/><br/>
 * This file is part of the Security Shepherd Project.
 * 
 * The Security Shepherd project is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.<br/>
 * 
 * The Security Shepherd project is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.<br/>
 * 
 * You should have received a copy of the GNU General Public License
 * along with the Security Shepherd project.  If not, see <http://www.gnu.org/licenses/>. 
 *
 * @author Mark Denihan
 */
//No Quotes In level Name
String levelName = "Poor Validation 2";
//Alphanumeric Only
String levelHash = "20e8c4bb50180fed9c1c8d1bf6af5eac154e97d3ce97e43257c76e73e3bbe5d5";
//Level blurb can be writen here in HTML OR go into the HTML body and write it there. Nobody will update this but you
String levelBlurb = "Not used - See Below";

ShepherdLogManager.logEvent(request.getRemoteAddr(), request.getHeader("X-Forwarded-For"), levelName + " Accessed");
if (request.getSession() != null)
{
	HttpSession ses = request.getSession();
	//Getting CSRF Token from client
	Cookie tokenCookie = null;
	try
	{
		tokenCookie = Validate.getToken(request.getCookies());
	}
	catch(Exception htmlE)
	{
		ShepherdLogManager.logEvent(request.getRemoteAddr(), request.getHeader("X-Forwarded-For"), levelName +".jsp: tokenCookie Error:" + htmlE.toString());
	}
	// validateSession ensures a valid session, and valid role credentials
	// If tokenCookie == null, then the page is not going to continue loading
	if (Validate.validateSession(ses) && tokenCookie != null)
	{
		ShepherdLogManager.logEvent(request.getRemoteAddr(), request.getHeader("X-Forwarded-For"), levelName + " has been accessed by " + ses.getAttribute("userName").toString(), ses.getAttribute("userName"));
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<title>Security Shepherd - <%= levelName %></title>
	<link href="../css/lessonCss/theCss.css" rel="stylesheet" type="text/css" media="screen" />
	
</head>
<body>
	<script type="text/javascript" src="../js/jquery.js"></script>
		<div id="contentDiv">
			<h2 class="title"><%= levelName %></h2>
			<p> 
				If you can buy trolls for free you'll receive the key for this level!
				<br/>
				<br/>
				<h3>Super Meme Shopping</h3>
				Use this shop to buy whatever old memes you like!
				<br />
				<br />
				<form id="leForm" action="javascript:;">
					<table>
					<!-- Header -->
					<tr>
						<th>Picture</th>
						<th>Cost</th>
						<th>Quantity</th>
					</tr>
					<!-- Rage Row -->
					<tr>
						<td><img width="50px" height="50px" src="<%= levelHash %>/rage.png"/></td>
						<td>$45</td>
						<td><input type="text" style="width: 20px" value="0" id="numberOfRage" autocomplete="off"/>
					</tr>
					<!-- NotBad Row -->
					<tr>
						<td><img width="50px" height="50px" src="<%= levelHash %>/notbad.jpeg"/></td>
						<td>$15</td>
						<td><input type="text" style="width: 20px" value="0" id="numberOfNotBad" autocomplete="off"/>
					</tr>
					<!-- Troll Row -->
					<tr>
						<td><img width="50px" height="50px" src="<%= levelHash %>/troll.png"/></td>
						<td>$3000</td>
						<td><input type="text" style="width: 20px" value="0" id="numberOfTroll" autocomplete="off"/>
					</tr>
					<!-- MeGusta Row -->
					<tr>
						<td><img width="50px" height="50px" src="<%= levelHash %>/megusta.png"/></td>
						<td>$30</td>
						<td><input type="text" style="width: 20px" value="0" id="numberOfMegusta" autocomplete="off"/>
					</tr>
					</table>
					Please select how many items you would like to buy and click submit
					<table>
					<tr><td>			
						<div id="submitButton">
						<input type="submit" value="Place Order"/></div>
						<p style="display: none;" id="loadingSign">Loading...</p>
					</td></tr>
					</table>
				</form>
				
				<div id="resultsDiv"></div>
			</p>
		</div>
		<script>
			$("#leForm").submit(function(){
				var theMegustaAmount = $("#numberOfMegusta").val();
				var theTrollAmount = $("#numberOfTroll").val();
				var theRageAmount = $("#numberOfRage").val();
				var theNotBadAmount = $("#numberOfNotBad").val();
				$("#submitButton").hide("fast");
				$("#loadingSign").show("slow");
				$("#resultsDiv").hide("slow", function(){
					var ajaxCall = $.ajax({
						type: "POST",
						url: "<%= levelHash %>",
						data: {
							megustaAmount: theMegustaAmount, 
							trollAmount: theTrollAmount,
							rageAmount: theRageAmount, 
							notBadAmount: theNotBadAmount
						},
						async: false
					});
					if(ajaxCall.status == 200)
					{
						$("#resultsDiv").html(ajaxCall.responseText);
					}
					else
					{
						$("#resultsDiv").html("<p> An Error Occurred: " + ajaxCall.status + " " + ajaxCall.statusText + "</p>");
					}
					$("#resultsDiv").show("slow", function(){
						$("#loadingSign").hide("fast", function(){
							$("#submitButton").show("slow");
						});
					});
				});
			});
		</script>
		<% if(Analytics.googleAnalyticsOn) { %><%= Analytics.googleAnalyticsScript %><% } %>
</body>
</html>
<%
	}
	else
	{
		response.sendRedirect("../loggedOutSheep.html");
	}
}
else
{
	response.sendRedirect("../loggedOutSheep.html");
}
%>