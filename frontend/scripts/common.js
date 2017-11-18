var BASE_PATH = "http://localhost:3000"

setInterval(function() {
  $("#alerts").empty()
}, 10000)

function getJwt() {
  return Cookies.get("jwt")
}

function getHeaders() {
  return {
    'Authorization': 'Beared ' + getJwt()
  }
}

function createButton(classes, text, onclick) {
  return $("<button></button>")
      .addClass(classes)
      .text(text)
      .click(onclick)
}

function createAlert(classes, dissmissable, text) {
  console.log("common::createAlert")
  d = $("<div>", {"class": classes, "role": "alert"})
  d.html(text)
  if(dissmissable) {
    d.append($("<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
        + "<span aria-hidden='true'>&times;</span>"
        + "</button>"))
  }
  return d
}

logged_in_pages = ["index.html", "dashboard.html", "signout.html", "about.html"]
logged_in_page_names = ["Home", "Dashboard", "Sign out", "About"]
admin_pages = ["index.html", "dashboard.html", "users.html", "jogging_logs.html", "signout.html", "about.html"]
admin_page_names = ["Home", "Dashboard", "Manage users", "Manage jogging logs", "Sign out", "About"]
manager_pages = ["index.html", "dashboard.html", "users.html", "signout.html", "about.html"]
manager_page_names= ["Home", "Dashboard", "Manage users", "Sign out", "About"]
public_pages = ["index.html", "login.html", "signup.html", "about.html"]
public_page_names = ["Home", "Login", "Sign up", "About"]

function renderMenu(active_page, pages, names) {
  console.log("renderMenu()")
  for(i = 0; i < pages.length; ++ i) {
    _a = $('<a></a>').addClass(pages[i] == active_page ? "nav-link active" : "nav-link").text(names[i]) .attr("href", pages[i])
    $("#navbarList").append(
      $('<li></li>').addClass("nav-item")
          .append(
            _a
        )
    )
  }
}

function buildNav(active_page) {
  getUser(function(user) {
    Cookies.set("user", user)
    console.log("Got user")
    console.log(user)
    if (user.role == "admin") {
      renderMenu(active_page, admin_pages, admin_page_names)
    } else if(user.role == "manager") {
      renderMenu(active_page, manager_pages, manager_page_names)
    } else {
      renderMenu(active_page, logged_in_pages, logged_in_page_names)
    }
  }, function(err) {
    console.log("There was an error")
    console.log(err);
    renderMenu(active_page, public_pages, public_page_names)
  })
}

function getUser(success, fail) {
  $.ajax({
    url: BASE_PATH + "/user/current",
    type: "GET",
    headers: getHeaders(),
    success: function (result) {
      if(success) {
        success(result)
      }
    },
    error: function (error) {
      if(fail) {
        fail(error)
      }
    }
  });
}

function getJoggingLogs(success, fail) {
  $.ajax({
    url: BASE_PATH + "/jogging_logs",
    type: "GET",
    headers: getHeaders(),
    success: function (result) {
      if(success) {
        success(result)
      }
    },
    error: function (error) {
      if(fail) {
        fail(error)
      }
    }
  });
}

function updateJoggingLog(jogging_log, success, fail) {
  $.ajax({
    url: BASE_PATH + "/jogging_logs/" + jogging_log.id ,
    type: "PATCH",
    headers: getHeaders(),
    data: { jogging_log },
    dataType: 'json',
    success: function (result) {
      if(success) {
        success(result)
      }
    },
    error: function (error) {
      if(fail) {
        fail(error)
      }
    }
  });
}

function createJoggingLog(jogging_log, success, fail) {
  console.log('create')
  console.log(jogging_log)
  $.ajax({
    url: BASE_PATH + "/jogging_logs",
    type: "POST",
    headers: getHeaders(),
    data: { jogging_log },
    dataType: 'json',
    success: function (result) {
      if(success) {
        success(result)
      }
    },
    error: function (error) {
      if(fail) {
        fail(error)
      }
    }
  });
}

function deleteJoggingLog(jogging_log, success, fail) {
  console.log('delete')
  console.log(jogging_log)
  $.ajax({
    url: BASE_PATH + "/jogging_logs/" + jogging_log.id,
    type: "DELETE",
    headers: getHeaders(),
    dataType: 'json',
    success: function (result) {
      if(success) {
        success(result)
      }
    },
    error: function (error) {
      if(fail) {
        fail(error)
      }
    }
  });
}

// for admins and managers
function getUsers(success, fail) {
  console.log('get users')
  $.ajax({
    url: BASE_PATH + "/users",
    type: "GET",
    headers: getHeaders(),
    dataType: 'json',
    success: function (result) {
      if(success) {
        success(result)
      }
    },
    error: function (error) {
      if(fail) {
        fail(error)
      }
    }
  });
}
function createUser(user, success, fail) {
  console.log('create user')
  console.log(user)
  $.ajax({
    url: BASE_PATH + "/user",
    type: "POST",
    headers: getHeaders(),
    data: { user },
    dataType: 'json',
    success: function (result) {
      if(success) {
        success(result)
      }
    },
    error: function (error) {
      if(fail) {
        fail(error)
      }
    }
  });
}

function updateUser(user, success, fail) {
  console.log('update user')
  console.log(user)
  $.ajax({
    url: BASE_PATH + "/user/" + user.id,
    type: "PATCH",
    headers: getHeaders(),
    data: { user },
    dataType: 'json',
    success: function (result) {
      if(success) {
        success(result)
      }
    },
    error: function (error) {
      if(fail) {
        fail(error)
      }
    }
  });
}

function deleteUser(user, success, fail) {
  console.log('delete')
  console.log(user)
  $.ajax({
    url: BASE_PATH + "/user/" + user.id,
    type: "DELETE",
    headers: getHeaders(),
    dataType: 'json',
    success: function (result) {
      if(success) {
        success(result)
      }
    },
    error: function (error) {
      if(fail) {
        fail(error)
      }
    }
  });
}

function getAdminJoggingLogs(success, fail) {
  $.ajax({
    url: BASE_PATH + "/admin/jogging_logs",
    type: "GET",
    headers: getHeaders(),
    success: function (result) {
      if(success) {
        success(result)
      }
    },
    error: function (error) {
      if(fail) {
        fail(error)
      }
    }
  });
}
