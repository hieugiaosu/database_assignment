const jwt = require("jsonwebtoken");
const jwtConfig = require("../config/auth.js");

function authenticateToken(req, res, next) {
  const token = req.headers["authorization"]?.split(" ")[1];
  // console.log(token);
  if (token == null) return res.status(401).send("Access token not found");

  try {
    jwt.verify(token, jwtConfig.secret, (err, user) => {
      if (err) return res.status(403).send("Access token invalid");
      req.user = user;
      next();
    });
  } catch (err) {
    console.log(err);
    return res.status(500).send("An error occurred during authentication");
  }
  // next();
}

module.exports = authenticateToken;
