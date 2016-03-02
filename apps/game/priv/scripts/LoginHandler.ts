module LoginHandler {
  export function message(msg) {
    switch (msg[0]) {
      case 'chat':
        console.log(msg[1]);
        break;
      default:
        console.log('UNKNOWN MESSAGE: ', msg);
    }
  }
}
