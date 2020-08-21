const params = new URL(self.location.href).searchParams;

self.createError = (message) => {
  if (params.get('error') === 'DOMException-TypeError') {
    return new DOMException(message, 'TypeError');
  } else {
    return new Error(message);
  }
};

onerror = function() {
  if (params.has('throw-in-onerror')) {
    throw createError('Throw in error handler');
  }
  return false;
};
onmessage = function() {
  throw createError('Throw in message handler');
  return false;
};

if (params.has('throw-in-toplevel')) {
  throw createError('Throw in toplevel');
}

if (params.has('throw-in-setTimeout-function')) {
  // To test the behavior of setTimeout(), raw setTimeout() is used.
  setTimeout(() => { throw createError('Throw in setTimeout function') }, 0);
}

if (params.has('throw-in-setTimeout-string')) {
  // To test the behavior of setTimeout(), raw setTimeout() is used.
  setTimeout("throw createError('Throw in setTimeout string')", 0);
}
