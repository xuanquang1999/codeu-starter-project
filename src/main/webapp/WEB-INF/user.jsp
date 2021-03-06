<!--
Copyright 2019 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.codeu.data.Message" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.google.common.flogger.FluentLogger" %>
<% BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
    String memeUploadUrl = blobstoreService.createUploadUrl("/messages");
    String avatarUploadUrl = blobstoreService.createUploadUrl("/avatar");
    List<Message> messages = (List<Message>) request.getAttribute("messages");

    String urlUserEmail = (String)request.getAttribute("urlUserEmail");
    String loggedInUserEmail = (String)request.getAttribute("loggedInUserEmail");
    FluentLogger logger = FluentLogger.forEnclosingClass();
    logger.atInfo().log("urlUserEmail: %s; loggedInUserEmail: %s", urlUserEmail, loggedInUserEmail);

    String visibilityTag = urlUserEmail.equals(loggedInUserEmail) ? "" : "hidden"; %>

<!DOCTYPE html>
<html>
<head>
    <title><%=urlUserEmail%></title>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css?family=Roboto&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/bootstrap.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/user-page.css" rel="stylesheet">
    <script src="https://cdn.ckeditor.com/ckeditor5/12.2.0/classic/ckeditor.js"></script>
</head>
<body>
<nav>
    <ul id="navigation">
        <li><a href="${pageContext.request.contextPath}/">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/aboutus.html">About Our Team</a></li>
        <li><a href="${pageContext.request.contextPath}/stats.html">Stats</a></li>
        <li><a href="${pageContext.request.contextPath}/map.html">Map</a></li>
        <li><a href="${pageContext.request.contextPath}/feed">Message Feed</a></li>

        <li class="right"><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
        <li class="right"><a href="${pageContext.request.contextPath}/setting.html">Settings</a></li>
        <li class="right"><a href="${pageContext.request.contextPath}/users/<%=loggedInUserEmail%>">Your Page</a></li>
    </ul>
</nav>

<div id="container">

    <div class="row" style="margin-left: 10px">
        <div class="col-3" id="user-information-layout">
            <div class="card border" style="padding: 5px; margin-left: 30px; margin: 10px;">

                <img class="card-img-top" src="<%=
                            (request.getAttribute("avatarUrl") == "")?
                                "/images/avatar-placeholder.gif" :
                                request.getAttribute("avatarUrl")
                            %>"
                     width="90%"
                     alt="Avatar">

                <div class="card-body">

                    <h4 id="page-title" class="text-center">
                        <%=request.getAttribute("displayedName")%>
                    </h4>

                    <hr/>

                    <p> <%=request.getAttribute("about")%> </p>

                </div>

            </div>

            <div class="<%=visibilityTag%>" style="margin-left: 15px">
                <form method="POST" action="<%= avatarUploadUrl %>" enctype="multipart/form-data">
                    Upload avatar: <input type="file" name="avatar" size="60" />
                    <br/>
                    <br/>
                    <input type="submit" value="Set Avatar" class="btn btn-primary" />
                </form>
            </div>

            <div class="form-group <%=visibilityTag%>" style="margin: 15px">
                <form id="about-me-form" action="/about" method="POST">
                    <textarea id="about-me-input" name="about-me" placeholder="Tell something about yourself" class="form-control" rows=4 required></textarea>
                    <br/>
                    <input type="submit" value="Update" class="btn btn-primary">
                </form>
            </div>

        </div>

        <div class="col-9" id="meme-list-layout" style="padding-right: 50px">
            <div class="form-group <%=visibilityTag%>">
                <form style="margin-top: 10px" id="message-form" action="<%= memeUploadUrl %>" method="POST" enctype="multipart/form-data">
                    <textarea name="text" id="message-input" class="form-control"></textarea>
                    <br/>
                    Upload meme:
                    <input type="file" name="image" style="margin-left: 15px"/>
                    <br/>
                    <br/>
                    <input type="submit" value="Upload" class="btn btn-primary">
                    <script>
                        const config = {removePlugins: ['ImageUpload'], placeholder: 'Meme title/description'};
                        ClassicEditor.create(document.getElementById('message-input'), config)
                    </script>
                </form>

                <hr/>
            </div>

            <div id="message-container">
                <%
                    if (messages.size() == 0) {
                %>This user has no posts yet<%
            } else {
                for (Message message : messages) {
            %>
                <div class="message-div">
                    <div class="message-header"><%=message.getUser().getDisplayedName().equals("")?
                            message.getUser().getEmail() : message.getUser().getDisplayedName()%> - <%= (new Date(message.getTimestamp())).toString()%>
                    </div>
                    <div class="message-body"><%=message.getText()%>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>

    </div>

</div>

<script src="${pageContext.request.contextPath}/js/jquery-3.4.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
</body>
</html>
