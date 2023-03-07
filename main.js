socket.on("D@3ie", (event) => {
  console.log(event)
});

socket.io.on("error", (error) => {
  console.error(error); // sorry?
});

// socket.offAny(); :|
