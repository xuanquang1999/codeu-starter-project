/*
 * Copyright 2019 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Adds a login or logout link to the page, depending on whether the user is
 * already logged in.
 */
function addLoginOrLogoutLinkToNavigation() {
  const navigationElement = document.getElementById('navigation');
  if (!navigationElement) {
    console.warn('Navigation element not found!');
    return;
  }

  fetch('/login-status')
      .then((response) => {
    return response.json();
})
.then((loginStatus) => {
    navigationElement.appendChild(createListItem(createLink('stats.html', 'Stats')), false);
  navigationElement.appendChild(createListItem(createLink('map.html', 'Map')), false);
  navigationElement.appendChild(createListItem(createLink('/feed', 'Message Feed')), false);

  if (loginStatus.isLoggedIn) {
    navigationElement.appendChild(createListItem(createLink('/logout', 'Logout'), true));
    navigationElement.appendChild(createListItem(createLink('/setting.html', 'Settings'), true));
    navigationElement.appendChild(createListItem(createLink('/users/' + loginStatus.username, 'Your Page'), true));
  } else {
    navigationElement.appendChild(
        createListItem(createLink('/login', 'Login'), true));
  }
});
}

/**
 * Creates an li element.
 * @param {Element} childElement
 * @return {Element} li element
 */
function createListItem(childElement, isRightAligned) {
  const listItemElement = document.createElement('li');
  if (isRightAligned)
    listItemElement.classList.add('right');
  listItemElement.appendChild(childElement);
  return listItemElement;
}

/**
 * Creates an anchor element.
 * @param {string} url
 * @param {string} text
 * @return {Element} Anchor element
 */
function createLink(url, text) {
  const linkElement = document.createElement('a');
  linkElement.appendChild(document.createTextNode(text));
  linkElement.href = url;
  return linkElement;
}
