const express = require('express');
const cors = require('cors'); 
const app = express();
const cookieParser = require('cookie-parser');
// const authenticateToken = require('./middleware/authenticateToken');

app.use(express.json());
app.use(cors());
app.use(cookieParser());

const db = require("./models");


// Routers
const printerRouter = require("./routers/printerRouters");
app.use("/printers",  printerRouter);

const historyRouter = require("./routers/historyRouters");
app.use("/history",  historyRouter);

const printingRouter = require("./routers/printingRouters");
app.use("/printing",printingRouter);

const authRouter = require('./routers/authRouters');
app.use("/auth", authRouter);

const adminRouter = require('./routers/adminRouters');
app.use("/admin", adminRouter);


const PORT = process.env.PORT || 3001;

db.sequelize.sync().then(() => {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
});
