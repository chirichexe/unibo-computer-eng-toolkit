<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>

<%
    String inputText = request.getParameter("text");
	if (inputText == null){
		response.sendRedirect("index.jsp");
	} else {
		String newText = inputText.replace("a", "b");
		response.sendRedirect("S2?text=" + newText);	
	}	
%>

