const express = require('express');
const mysql = require("mysql");
const dotenv = require('dotenv');
const crypto = require('crypto');
const app = express();
dotenv.config({ path: './.env' });
var http = require('http');
const PORT = 8080;
var url = require('url');
app.set('view engine', 'hbs');
const bcrypt = require("bcryptjs");
app.use(express.urlencoded({ extended: 'false' }));
app.use(express.json());
app.use(express.static('public'));
app.use('/images', express.static('images'));

console.log(process.env.DATABASE_HOST);

const db = mysql.createConnection({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_ROOT,
    port: 3306,
    database: process.env.DATABASE
});


// const db = mysql.createConnection({
//     host: "localhost",
//     user: "root",
//     port: 3306,
//     database: "health",
//     password: "Alzunified@123"
// });


db.connect((error) => {
    if (error) {
        console.log(error)
    } else {
        console.log("MySQL connected!")
    }
});

// **********************************************Register**************************************************


function generateDatesArray(year) {
    const startDate = new Date(year, 8, 1);
    const endDate = new Date(2024, 12, 31);
    const datesArray = [];

    for (let date = startDate; date <= endDate; date.setDate(date.getDate() + 1)) {
        datesArray.push(date.toISOString().split('T')[0]);
    }

    return datesArray;
}

// Function to insert dates into the MySQL table
async function insertDatesIntoTable(name) {
    const year = 2023; // Change this to the desired year
    const datesArray = generateDatesArray(year);

    try {
        for (const date of datesArray) {
            console.log(datesArray);
            db.query('INSERT INTO ' + name + ' SET?', { dates: date, food: 0, medicine: 0, activity: 0, foodcompleted: 0, medicinecompleted: 0, activitycompleted: 0 }, (err3, data3) => {
                if (err3) {
                }
            });
        }

        console.log(`Inserted ${datesArray.length} dates into the table.`);
    } catch (error) {
        console.error('Error:', error);
    }
}



async function insertDateslogs(name) {
    const year = 2023; // Change this to the desired year
    const datesArray = generateDatesArray(year);

    try {
        for (const date of datesArray) {
            console.log(datesArray);
            db.query('INSERT INTO ' + name + ' SET?', { dates: date }, (err3, data3) => {
                if (err3) {
                }
            });
        }

        console.log(`Inserted ${datesArray.length} dates into the table.`);
    } catch (error) {
        console.error('Error:', error);
    }
}




app.post("/register", (req, res) => {
    let data;


    const { email, name, contactnumber, gender, dob, password, status } = req.body;
    db.query('SELECT email FROM register WHERE email = ?', [email], async (error, datas) => {
        if (error) {
            console.log("1st erroe");
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        }
        if (datas.length > 0) {
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "exists" }))


        } else {
            console.log("full");

            let hashedPassword = await bcrypt.hash(password, 8)
            let dt = Math.floor(new Date().getTime() / 1000)
            let mrandom = crypto.randomInt(100000, 999999);
            let prandom = crypto.randomInt(100000, 999999);
            let uid = crypto.randomInt(10, 999999);
            let fuid;
            let logs;
            uid = dt + uid;
            fuid = uid + "T";
            logs = uid + "logs";

            db.query('INSERT INTO register SET?', { name: name, email: email, password: hashedPassword, contact: contactnumber, gender: gender, dob: dob, status: 0, date: dt, verification: 0, uid: uid, block: 0, profile: 0, profileimg: "no image", emergencyemail: "" }, (err, data) => {
                if (err) {
                    res.setHeader('Content-Type', 'application/json');
                    res.send(JSON.stringify({ status: "error" }))
                } else {
                    console.log("Enet");
                    db.query('INSERT INTO otp SET?', { email: email, emailotp: mrandom, phoneotp: prandom, date: dt }, (err, data1) => {
                        if (err) {
                            res.setHeader('Content-Type', 'application/json');
                            res.send(JSON.stringify({ status: "error" }))
                        } else {

                            console.log("Here");
                            db.query('CREATE TABLE ' + fuid + '(id INT NOT NULL AUTO_INCREMENT,dates VARCHAR(50),food INT(10),medicine INT(10),activity INT(10),PRIMARY KEY (id),foodcompleted INT(10),medicinecompleted INT(10),activitycompleted INT(10))', (err1, data2) => {
                                if (err1) {
                                    console.log(err1);
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "error" }))
                                } else {
                                    insertDatesIntoTable(fuid);
                                    db.query('CREATE TABLE ' + logs + '(id INT NOT NULL AUTO_INCREMENT,dates VARCHAR(50),PRIMARY KEY (id))', (err12, data22) => {
                                        if (err12) {
                                            console.log(err12);
                                            res.setHeader('Content-Type', 'application/json');
                                            res.send(JSON.stringify({ status: "error" }))
                                        } else {
                                            insertDateslogs(logs);
                                            res.setHeader('Content-Type', 'application/json');
                                            res.send(JSON.stringify({ status: "success", emailotp: mrandom, phoneotp: prandom }))
                                        }

                                    });
                                }
                            });
                        }
                    })






                }

            })

        }


    })
});

//*************************************************Login******************************************************* */



app.post("/login", (req, res) => {
    let data;
    const { email, password } = req.body;
    db.query('SELECT email,password,name,uid,status,verification,block,emergencyemail FROM register WHERE email = ?', [email], async (error, datas) => {
        if (error) {
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        }
        if (datas.length > 0) {
            let dt = Math.floor(new Date().getTime() / 1000)
            let sessionid = crypto.randomInt(100000, 999999999999);

            if (datas[0]['email'] == email) {
                bcrypt.compare(password, datas[0]['password'], (err, dataf) => {

                    if (dataf) {

                        db.query('INSERT INTO session SET?', { email: email, sessionid: sessionid, date: dt }, (err, data1) => {
                            if (err) {
                                res.setHeader('Content-Type', 'application/json');
                                res.send(JSON.stringify({ status: "error" }))
                            } else {
                                if (datas[0]['status'] == 0 && datas[0]['block'] == 0) {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "success", name: datas[0]['name'], uid: datas[0]['uid'], verify: datas[0]['verification'], session: sessionid, block: datas[0]['block'], emergencyemail: datas[0]['emergencyemail'] }))
                                } else {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "error" }))
                                }

                            }
                        })
                    } else {
                        res.setHeader('Content-Type', 'application/json');
                        res.send(JSON.stringify({ status: "error" }))

                    }




                })

            } else {
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({ status: "error" }))
            }


            // res.send(JSON.stringify({ status: "Success" }))

        } else {
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        }


    })
});


// **********************************************Verification**************************************************/






//***************************************************Activity************************************************ */

app.post("/activity", (req, res) => {
    const { email, uid, date } = req.body;
    const fuid = uid + "t";

    db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [date], async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

    });
});


//************************************************Date Today Activity */

app.post("/datetodayactivity", (req, res) => {
    const { uid, date } = req.body;
    const fuid = uid + "t";

    db.query('SELECT * FROM activities WHERE uid= ? AND  status =0 ', [uid, date], async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

    });
});



//************************************************Date Today Medicine */

app.post("/datetodaymedicine", (req, res) => {
    const { uid, date } = req.body;
    const fuid = uid + "t";

    db.query('SELECT * FROM medicines WHERE uid= ? AND  status =0 ', [uid, date], async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

    });
});


//************************************************Date Today Food */

app.post("/datetodayfood", (req, res) => {
    const { uid, date } = req.body;
    const fuid = uid + "t";

    db.query('SELECT * FROM food WHERE uid= ? AND  status =0 ', [uid, date], async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

    });
});



//************************************************Update dashboard status*/

app.post("/finalupdateactivity", (req, res) => {
    const { activityid, date, uid, name } = req.body;
    const fuid = uid + "logs";
    console.log(activityid);
    console.log(date);
    console.log(fuid);
    const tuid = uid + "t";
    var tactivity = 0;
    var fname = "";

    db.query('UPDATE ' + fuid + ' SET ' + activityid + ' =1 WHERE dates = ? ', [date], async (error, datas) => {
        // if(error){
        //     res.setHeader('Content-Type', 'application/json');
        //     res.send(JSON.stringify({ status: "error" }))
        // }else{
        //     res.setHeader('Content-Type', 'application/json');
        //     res.send(JSON.stringify({ status: "success" }))
        // }



        if (name == "activity") {
            fname = "activitycompleted";
        }
        if (name == "food") {
            fname = "foodcompleted";
        }
        if (name == "medical") {
            fname = "medicinecompleted";
        }

        db.query('SELECT * FROM ' + tuid + ' WHERE dates= ?', [date], async (error11, datas11) => {
            tactivity = datas11[0][fname];
            console.log(tactivity);
            tactivity = tactivity + 1;
            console.log(tactivity);

            if (datas11) {


                db.query('UPDATE ' + tuid + ' SET ' + fname + ' = ? WHERE dates = ?', [tactivity, date], (err16, data16) => {
                    if (err16) {
                        res.setHeader('Content-Type', 'application/json');
                        res.send(JSON.stringify({ status: "error" }))
                    } else {
                        res.setHeader('Content-Type', 'application/json');
                        res.send(JSON.stringify({ status: "success" }))
                    }

                });
            } else {
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({ status: "error" }))
            }




        });







    });
});





//***********************************************Get Activity till date */

app.post("/activitytilldate", (req, res) => {
    const { uid, date } = req.body;
    const fuid = uid + "t";

    db.query('SELECT dates as Date,activity as TotalActivity ,activitycompleted as ActivityCompleted FROM ' + fuid + ' WHERE dates <= ?', [date], async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

        if (error) {
            console.log(error);
        }

    });
});


//***********************************************Get Medicine till date */

app.post("/medicinetilldate", (req, res) => {
    const { uid, date } = req.body;
    const fuid = uid + "t";

    db.query('SELECT dates as Date,medicine as TotalMedicine ,medicinecompleted as MedicineCompleted FROM ' + fuid + ' WHERE dates <= ?', [date], async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

        if (error) {
            console.log(error);
        }

    });
});
//***********************************************Profile */

app.post("/getprofile", (req, res) => {
    const { uid } = req.body;

    db.query('SELECT contact,gender,dob,date,profile,profileimg,emergencyemail FROM register WHERE uid = ?', [uid], async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

        if (error) {
            console.log(error);
        }

    });
});



//***********************************************Logs */

app.post("/logs", (req, res) => {
    const { uid, date } = req.body;
    console.log(uid);
    const fuid = uid + "logs";

    db.query('SELECT * FROM ' + fuid + ' WHERE dates = ?', [date], async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

        if (error) {
            console.log(error);
        }

    });
});

//*********************************************** Activity Logs */

app.post("/activitylogs", (req, res) => {
    const { uid, date } = req.body;
    //const fuid = uid + "logs";

    db.query('SELECT * FROM activities WHERE uid = ? and status=0 AND NOT date>=?', [uid, date], async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

        if (error) {
            console.log(error);
        }

    });
});

//*********************************************** Medicine Logs */

app.post("/medicinelogs", (req, res) => {
    const { uid, date } = req.body;
    //const fuid = uid + "logs";

    db.query('SELECT * FROM medicines WHERE uid = ? and status=0 AND NOT date>=?', [uid, date], async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

        if (error) {
            console.log(error);
        }

    });
});


//*********************************************** Food Logs */

app.post("/foodlogs", (req, res) => {
    const { uid, date } = req.body;
    //const fuid = uid + "logs";

    db.query('SELECT * FROM food WHERE uid = ? and status=0 AND NOT date>=?', [uid, date], async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

        if (error) {
            console.log(error);
        }

    });
});


//***********************************************Get Food till date */

app.post("/foodtilldate", (req, res) => {
    const { uid, date } = req.body;
    const fuid = uid + "t";

    db.query('SELECT dates as Date,food as TotalFood ,foodcompleted as FoodCompleted FROM ' + fuid + ' WHERE dates <= ?', [date], async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

        if (error) {
            console.log(error);
        }

    });
});



//************************************************Delete Activity****************************************** */


app.post("/deleteactivity", (req, res) => {
    const { activityid, uid, date, frequency, regdate } = req.body;
    const fuid = uid + "t";
    const logs = uid + "logs";
    var tactivity;
    var nactivity;
    var lactivity;
    var id = 0;

    if (frequency == 0) {
        db.query('ALTER TABLE ' + logs + ' DROP COLUMN ' + activityid, async (error, datas) => {
            if (error) {
                console.log(error);
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({ status: "error" }))
            } else {
                db.query('UPDATE activities SET ? WHERE activityid = ?', [{ status: 1 }, activityid], (err12, data12) => {
                    if (err12) {
                        res.setHeader('Content-Type', 'application/json');
                        res.send(JSON.stringify({ status: "error" }))
                    } else {

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [regdate], async (error11, datas11) => {
                            tactivity = datas11[0]['activity'];
                            tactivity = tactivity - 1;

                            if (datas11) {

                                db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ activity: tactivity }, regdate], (err16, data16) => {
                                    if (err16) {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "error" }))
                                    } else {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "success" }))
                                    }

                                });
                            } else {
                                res.setHeader('Content-Type', 'application/json');
                                res.send(JSON.stringify({ status: "error" }))
                            }




                        });


                    }

                });

            }

        });
    }
    if (frequency == 1) {
        db.query('ALTER TABLE ' + logs + ' DROP COLUMN ' + activityid, async (error, datas) => {
            if (error) {
                console.log(error);
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({ status: "error" }))
            } else {
                db.query('UPDATE activities SET ? WHERE activityid = ?', [{ status: 1 }, activityid], (err12, data12) => {
                    if (err12) {
                        res.setHeader('Content-Type', 'application/json');
                        res.send(JSON.stringify({ status: "error" }))
                    } else {

                        console.log(regdate);

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [regdate], async (error11, datas11) => {
                            tactivity = datas11[0]['activity'];
                            console.log(tactivity);
                            tactivity = tactivity - 1;
                            console.log(tactivity);

                            if (datas11) {

                                db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ activity: tactivity }, regdate], (err16, data16) => {
                                    if (err16) {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "error" }))
                                    } else {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "success" }))
                                    }

                                });
                            } else {
                                res.setHeader('Content-Type', 'application/json');
                                res.send(JSON.stringify({ status: "error" }))
                            }




                        });


                    }

                });

            }

        });

    }
    if (frequency == 2) {
        db.query('ALTER TABLE ' + logs + ' DROP COLUMN ' + activityid, async (error, datas) => {
            if (error) {
                console.log(error);
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({ status: "error" }))
            } else {
                db.query('UPDATE activities SET ? WHERE activityid = ?', [{ status: 1 }, activityid], (err12, data12) => {
                    if (err12) {
                        res.setHeader('Content-Type', 'application/json');
                        res.send(JSON.stringify({ status: "error" }))
                    } else {

                        console.log(regdate);

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates = ?', [date], async (error11, datas11) => {
                            tactivity = datas11[0]['activity'];
                            console.log(tactivity);
                            tactivity = tactivity - 1;
                            console.log(tactivity);
                            id = datas11[0]['id'];

                            if (error11) {
                                res.setHeader('Content-Type', 'application/json');
                                res.send(JSON.stringify({ status: "error" }))
                            } else {


                                db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ activity: tactivity }, date], (err12, data12) => {
                                    if (err12) {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "error" }))
                                    } else {
                                        id = id + 1;
                                        console.log("nextid");
                                        console.log(id);


                                        db.query('SELECT * FROM ' + fuid + ' WHERE id= ?', [id], async (error13, datas13) => {
                                            if (error13) {
                                                console.log(error13);
                                                res.setHeader('Content-Type', 'application/json');
                                                res.send(JSON.stringify({ status: "error" }))
                                            }
                                            nactivity = datas13[0]['activity'];
                                            nactivity = nactivity - 1;
                                            console.log(id);
                                            console.log(nactivity);


                                            db.query('UPDATE ' + fuid + ' SET ? WHERE id = ?', [{ activity: nactivity }, id], (err14, data14) => {
                                                if (err14) {
                                                    res.setHeader('Content-Type', 'application/json');
                                                    res.send(JSON.stringify({ status: "error" }))
                                                } else {

                                                    id = id + 1;
                                                    console.log("lastid");
                                                    console.log(id);


                                                    db.query('SELECT * FROM ' + fuid + ' WHERE id= ?', [id], async (error15, datas15) => {
                                                        lactivity = datas15[0]['activity'];
                                                        lactivity = lactivity - 1;


                                                        db.query('UPDATE ' + fuid + ' SET ? WHERE id >= ?', [{ activity: lactivity }, id], (err16, data14) => {
                                                            if (err16) {
                                                                res.setHeader('Content-Type', 'application/json');
                                                                res.send(JSON.stringify({ status: "error" }))
                                                            } else {
                                                                res.setHeader('Content-Type', 'application/json');
                                                                res.send(JSON.stringify({ status: "success" }))
                                                            }
                                                        });



                                                    });
                                                }
                                            });



                                        });
                                    }

                                });

                            }

                        });


                    }

                });

            }

        });


    }
});




//**************************************************Add Activity**************************** */

app.post("/addactivity", (req, res) => {
    let data;
    let fuid = "";
    let logs = "";
    var tactivity;
    var nactivity;
    var lactivity;
    var id = 0;



    const { name, description, frequency, time, remainder, date, uid, activityid, epo } = req.body;
    console.log(epo);
    db.query('INSERT INTO activities SET?', { name: name, description: description, frequency: frequency, time: time, remainder: remainder, date: date, status: 0, uid: uid, activityid: activityid, epoch: epo }, (err, data) => {
        if (err) {
            console.log(err);
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        } else {
            fuid = uid + "t";
            logs = uid + "logs";



            db.query('ALTER TABLE ' + logs + ' ADD ' + activityid + ' INT(1) DEFAULT 0', (err22, data22) => {
                if (err22) {
                    console.log(err22);
                    res.setHeader('Content-Type', 'application/json');
                    res.send(JSON.stringify({ status: "error" }))
                } else {

                    if (frequency == 0) {

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [date], async (error11, datas11) => {
                            tactivity = datas11[0]['activity'];
                            console.log(tactivity);
                            tactivity = tactivity + 1;

                            db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ activity: tactivity }, date], (err12, data12) => {
                                if (err12) {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "error" }))
                                } else {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "success" }))
                                }

                            });
                        });
                    }
                    if (frequency == 1) {

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [date], async (error11, datas11) => {
                            tactivity = datas11[0]['activity'];
                            console.log(tactivity);
                            tactivity = tactivity + 1;


                            db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ activity: tactivity }, date], (err12, data12) => {
                                if (err12) {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "error" }))
                                } else {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "success" }))
                                }

                            });
                        });
                    }
                    if (frequency == 2) {

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [date], async (error11, datas11) => {
                            tactivity = datas11[0]['activity'];
                            console.log(tactivity);
                            tactivity = tactivity + 1;
                            id = datas11[0]['id'];



                            db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ activity: tactivity }, date], (err12, data12) => {
                                if (err12) {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "error" }))
                                } else {
                                    id = id + 1;
                                    console.log("nextid");
                                    console.log(id);


                                    db.query('SELECT * FROM ' + fuid + ' WHERE id= ?', [id], async (error13, datas13) => {
                                        if (error13) {
                                            console.log(error13);
                                            res.setHeader('Content-Type', 'application/json');
                                            res.send(JSON.stringify({ status: "error" }))
                                        }
                                        nactivity = datas13[0]['activity'];
                                        nactivity = nactivity + 1;
                                        console.log(id);
                                        console.log(nactivity);


                                        db.query('UPDATE ' + fuid + ' SET ? WHERE id = ?', [{ activity: nactivity }, id], (err14, data14) => {
                                            if (err14) {
                                                res.setHeader('Content-Type', 'application/json');
                                                res.send(JSON.stringify({ status: "error" }))
                                            } else {

                                                id = id + 1;
                                                console.log("lastid");
                                                console.log(id);


                                                db.query('SELECT * FROM ' + fuid + ' WHERE id= ?', [id], async (error15, datas15) => {
                                                    lactivity = datas15[0]['activity'];
                                                    lactivity = lactivity + 1;


                                                    db.query('UPDATE ' + fuid + ' SET ? WHERE id >= ?', [{ activity: lactivity }, id], (err16, data14) => {
                                                        if (err16) {
                                                            res.setHeader('Content-Type', 'application/json');
                                                            res.send(JSON.stringify({ status: "error" }))
                                                        } else {
                                                            res.setHeader('Content-Type', 'application/json');
                                                            res.send(JSON.stringify({ status: "success" }))
                                                        }
                                                    });



                                                });
                                            }
                                        });



                                    });
                                }

                            });









                        });
                    }

                }

            });
        }
    });

});






//**************************************************Add Medicine**************************** */

app.post("/addmedicine", (req, res) => {
    let data;
    let fuid = "";
    let logs = "";
    var tactivity;
    var nactivity;
    var lactivity;
    var id = 0;



    const { name, description, frequency, time, remainder, date, uid, activityid, dosage } = req.body;

    db.query('INSERT INTO medicines SET?', { name: name, description: description, frequency: frequency, time: time, remainder: remainder, date: date, status: 0, uid: uid, activityid: activityid, dosage: dosage }, (err, data) => {
        if (err) {
            console.log(err);
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        } else {
            fuid = uid + "t";
            logs = uid + "logs";



            db.query('ALTER TABLE ' + logs + ' ADD ' + activityid + ' INT(1) DEFAULT 0', (err22, data22) => {
                if (err22) {
                    console.log(err22);
                    res.setHeader('Content-Type', 'application/json');
                    res.send(JSON.stringify({ status: "error" }))
                } else {

                    if (frequency == 0) {

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [date], async (error11, datas11) => {
                            tactivity = datas11[0]['medicine'];
                            console.log(tactivity);
                            tactivity = tactivity + 1;

                            db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ medicine: tactivity }, date], (err12, data12) => {
                                if (err12) {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "error" }))
                                } else {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "success" }))
                                }

                            });
                        });
                    }
                    if (frequency == 1) {

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [date], async (error11, datas11) => {
                            tactivity = datas11[0]['medicine'];
                            console.log(tactivity);
                            tactivity = tactivity + 1;


                            db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ medicine: tactivity }, date], (err12, data12) => {
                                if (err12) {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "error" }))
                                } else {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "success" }))
                                }

                            });
                        });
                    }
                    if (frequency == 2) {

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [date], async (error11, datas11) => {
                            tactivity = datas11[0]['medicine'];
                            console.log(tactivity);
                            tactivity = tactivity + 1;
                            id = datas11[0]['id'];



                            db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ medicine: tactivity }, date], (err12, data12) => {
                                if (err12) {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "error" }))
                                } else {
                                    id = id + 1;
                                    console.log("nextid");
                                    console.log(id);


                                    db.query('SELECT * FROM ' + fuid + ' WHERE id= ?', [id], async (error13, datas13) => {
                                        if (error13) {
                                            console.log(error13);
                                            res.setHeader('Content-Type', 'application/json');
                                            res.send(JSON.stringify({ status: "error" }))
                                        }
                                        nactivity = datas13[0]['medicine'];
                                        nactivity = nactivity + 1;
                                        console.log(id);
                                        console.log(nactivity);


                                        db.query('UPDATE ' + fuid + ' SET ? WHERE id = ?', [{ medicine: nactivity }, id], (err14, data14) => {
                                            if (err14) {
                                                res.setHeader('Content-Type', 'application/json');
                                                res.send(JSON.stringify({ status: "error" }))
                                            } else {

                                                id = id + 1;
                                                console.log("lastid");
                                                console.log(id);


                                                db.query('SELECT * FROM ' + fuid + ' WHERE id= ?', [id], async (error15, datas15) => {
                                                    lactivity = datas15[0]['medicine'];
                                                    lactivity = lactivity + 1;


                                                    db.query('UPDATE ' + fuid + ' SET ? WHERE id >= ?', [{ medicine: lactivity }, id], (err16, data14) => {
                                                        if (err16) {
                                                            res.setHeader('Content-Type', 'application/json');
                                                            res.send(JSON.stringify({ status: "error" }))
                                                        } else {
                                                            res.setHeader('Content-Type', 'application/json');
                                                            res.send(JSON.stringify({ status: "success" }))
                                                        }
                                                    });



                                                });
                                            }
                                        });



                                    });
                                }

                            });









                        });
                    }

                }

            });
        }
    });

});














app.get('/', (req, res) => {
    res.send("GET Request Called")
});


app.listen(PORT, function (err) {
    if (err) console.log(err);
    console.log("Server listening on PORT", PORT);
});


//************************************************Delete Medicine****************************************** */


app.post("/deletemedicine", (req, res) => {
    const { activityid, uid, date, frequency, regdate } = req.body;
    const fuid = uid + "t";
    const logs = uid + "logs";
    var tactivity;
    var nactivity;
    var lactivity;
    var id = 0;

    if (frequency == 0) {
        db.query('ALTER TABLE ' + logs + ' DROP COLUMN ' + activityid, async (error, datas) => {
            if (error) {
                console.log(error);
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({ status: "error" }))
            } else {
                db.query('UPDATE medicines SET ? WHERE activityid = ?', [{ status: 1 }, activityid], (err12, data12) => {
                    if (err12) {
                        res.setHeader('Content-Type', 'application/json');
                        res.send(JSON.stringify({ status: "error" }))
                    } else {

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [regdate], async (error11, datas11) => {
                            tactivity = datas11[0]['medicine'];
                            tactivity = tactivity - 1;

                            if (datas11) {

                                db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ medicine: tactivity }, regdate], (err16, data16) => {
                                    if (err16) {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "error" }))
                                    } else {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "success" }))
                                    }

                                });
                            } else {
                                res.setHeader('Content-Type', 'application/json');
                                res.send(JSON.stringify({ status: "error" }))
                            }




                        });


                    }

                });

            }

        });
    }
    if (frequency == 1) {
        db.query('ALTER TABLE ' + logs + ' DROP COLUMN ' + activityid, async (error, datas) => {
            if (error) {
                console.log(error);
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({ status: "error" }))
            } else {
                db.query('UPDATE medicines SET ? WHERE activityid = ?', [{ status: 1 }, activityid], (err12, data12) => {
                    if (err12) {
                        res.setHeader('Content-Type', 'application/json');
                        res.send(JSON.stringify({ status: "error" }))
                    } else {

                        console.log(regdate);

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [regdate], async (error11, datas11) => {
                            tactivity = datas11[0]['medicine'];
                            console.log(tactivity);
                            tactivity = tactivity - 1;
                            console.log(tactivity);

                            if (datas11) {

                                db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ medicine: tactivity }, regdate], (err16, data16) => {
                                    if (err16) {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "error" }))
                                    } else {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "success" }))
                                    }

                                });
                            } else {
                                res.setHeader('Content-Type', 'application/json');
                                res.send(JSON.stringify({ status: "error" }))
                            }




                        });


                    }

                });

            }

        });

    }
    if (frequency == 2) {
        db.query('ALTER TABLE ' + logs + ' DROP COLUMN ' + activityid, async (error, datas) => {
            if (error) {
                console.log(error);
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({ status: "error" }))
            } else {
                db.query('UPDATE medicines SET ? WHERE activityid = ?', [{ status: 1 }, activityid], (err12, data12) => {
                    if (err12) {
                        res.setHeader('Content-Type', 'application/json');
                        res.send(JSON.stringify({ status: "error" }))
                    } else {

                        console.log(regdate);

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates = ?', [date], async (error11, datas11) => {
                            tactivity = datas11[0]['medicine'];
                            console.log(tactivity);
                            tactivity = tactivity - 1;
                            console.log(tactivity);
                            id = datas11[0]['id'];

                            if (error11) {
                                res.setHeader('Content-Type', 'application/json');
                                res.send(JSON.stringify({ status: "error" }))
                            } else {


                                db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ medicine: tactivity }, date], (err12, data12) => {
                                    if (err12) {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "error" }))
                                    } else {
                                        id = id + 1;
                                        console.log("nextid");
                                        console.log(id);


                                        db.query('SELECT * FROM ' + fuid + ' WHERE id= ?', [id], async (error13, datas13) => {
                                            if (error13) {
                                                console.log(error13);
                                                res.setHeader('Content-Type', 'application/json');
                                                res.send(JSON.stringify({ status: "error" }))
                                            }
                                            nactivity = datas13[0]['medicine'];
                                            nactivity = nactivity - 1;
                                            console.log(id);
                                            console.log(nactivity);


                                            db.query('UPDATE ' + fuid + ' SET ? WHERE id = ?', [{ medicine: nactivity }, id], (err14, data14) => {
                                                if (err14) {
                                                    res.setHeader('Content-Type', 'application/json');
                                                    res.send(JSON.stringify({ status: "error" }))
                                                } else {

                                                    id = id + 1;
                                                    console.log("lastid");
                                                    console.log(id);


                                                    db.query('SELECT * FROM ' + fuid + ' WHERE id= ?', [id], async (error15, datas15) => {
                                                        lactivity = datas15[0]['medicine'];
                                                        lactivity = lactivity - 1;


                                                        db.query('UPDATE ' + fuid + ' SET ? WHERE id >= ?', [{ medicine: lactivity }, id], (err16, data14) => {
                                                            if (err16) {
                                                                res.setHeader('Content-Type', 'application/json');
                                                                res.send(JSON.stringify({ status: "error" }))
                                                            } else {
                                                                res.setHeader('Content-Type', 'application/json');
                                                                res.send(JSON.stringify({ status: "success" }))
                                                            }
                                                        });



                                                    });
                                                }
                                            });



                                        });
                                    }

                                });

                            }

                        });


                    }

                });

            }

        });


    }
});





//**************************************************Add Food**************************** */

app.post("/addfood", (req, res) => {
    let data;
    let fuid = "";
    let logs = "";
    var tactivity;
    var nactivity;
    var lactivity;
    var id = 0;



    const { name, description, frequency, time, remainder, date, uid, activityid } = req.body;

    db.query('INSERT INTO food SET?', { name: name, description: description, frequency: frequency, time: time, remainder: remainder, date: date, status: 0, uid: uid, activityid: activityid }, (err, data) => {
        if (err) {
            console.log(err);
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        } else {
            fuid = uid + "t";
            logs = uid + "logs";



            db.query('ALTER TABLE ' + logs + ' ADD ' + activityid + ' INT(1) DEFAULT 0', (err22, data22) => {
                if (err22) {
                    console.log(err22);
                    res.setHeader('Content-Type', 'application/json');
                    res.send(JSON.stringify({ status: "error" }))
                } else {

                    if (frequency == 0) {

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [date], async (error11, datas11) => {
                            tactivity = datas11[0]['food'];
                            console.log(tactivity);
                            tactivity = tactivity + 1;

                            db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ food: tactivity }, date], (err12, data12) => {
                                if (err12) {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "error" }))
                                } else {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "success" }))
                                }

                            });
                        });
                    }
                    if (frequency == 1) {

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [date], async (error11, datas11) => {
                            tactivity = datas11[0]['food'];
                            console.log(tactivity);
                            tactivity = tactivity + 1;


                            db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ food: tactivity }, date], (err12, data12) => {
                                if (err12) {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "error" }))
                                } else {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "success" }))
                                }

                            });
                        });
                    }
                    if (frequency == 2) {

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [date], async (error11, datas11) => {
                            tactivity = datas11[0]['food'];
                            console.log(tactivity);
                            tactivity = tactivity + 1;
                            id = datas11[0]['id'];



                            db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ food: tactivity }, date], (err12, data12) => {
                                if (err12) {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "error" }))
                                } else {
                                    id = id + 1;
                                    console.log("nextid");
                                    console.log(id);


                                    db.query('SELECT * FROM ' + fuid + ' WHERE id= ?', [id], async (error13, datas13) => {
                                        if (error13) {
                                            console.log(error13);
                                            res.setHeader('Content-Type', 'application/json');
                                            res.send(JSON.stringify({ status: "error" }))
                                        }
                                        nactivity = datas13[0]['food'];
                                        nactivity = nactivity + 1;
                                        console.log(id);
                                        console.log(nactivity);


                                        db.query('UPDATE ' + fuid + ' SET ? WHERE id = ?', [{ food: nactivity }, id], (err14, data14) => {
                                            if (err14) {
                                                res.setHeader('Content-Type', 'application/json');
                                                res.send(JSON.stringify({ status: "error" }))
                                            } else {

                                                id = id + 1;
                                                console.log("lastid");
                                                console.log(id);


                                                db.query('SELECT * FROM ' + fuid + ' WHERE id= ?', [id], async (error15, datas15) => {
                                                    lactivity = datas15[0]['food'];
                                                    lactivity = lactivity + 1;


                                                    db.query('UPDATE ' + fuid + ' SET ? WHERE id >= ?', [{ food: lactivity }, id], (err16, data14) => {
                                                        if (err16) {
                                                            res.setHeader('Content-Type', 'application/json');
                                                            res.send(JSON.stringify({ status: "error" }))
                                                        } else {
                                                            res.setHeader('Content-Type', 'application/json');
                                                            res.send(JSON.stringify({ status: "success" }))
                                                        }
                                                    });



                                                });
                                            }
                                        });



                                    });
                                }

                            });









                        });
                    }

                }

            });
        }
    });

});




//************************************************Delete Food****************************************** */


app.post("/deletefood", (req, res) => {
    const { activityid, uid, date, frequency, regdate } = req.body;
    const fuid = uid + "t";
    const logs = uid + "logs";
    var tactivity;
    var nactivity;
    var lactivity;
    var id = 0;

    if (frequency == 0) {
        db.query('ALTER TABLE ' + logs + ' DROP COLUMN ' + activityid, async (error, datas) => {
            if (error) {
                console.log(error);
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({ status: "error" }))
            } else {
                db.query('UPDATE food SET ? WHERE activityid = ?', [{ status: 1 }, activityid], (err12, data12) => {
                    if (err12) {
                        res.setHeader('Content-Type', 'application/json');
                        res.send(JSON.stringify({ status: "error" }))
                    } else {

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [regdate], async (error11, datas11) => {
                            tactivity = datas11[0]['food'];
                            tactivity = tactivity - 1;

                            if (datas11) {

                                db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ food: tactivity }, regdate], (err16, data16) => {
                                    if (err16) {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "error" }))
                                    } else {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "success" }))
                                    }

                                });
                            } else {
                                res.setHeader('Content-Type', 'application/json');
                                res.send(JSON.stringify({ status: "error" }))
                            }




                        });


                    }

                });

            }

        });
    }
    if (frequency == 1) {
        db.query('ALTER TABLE ' + logs + ' DROP COLUMN ' + activityid, async (error, datas) => {
            if (error) {
                console.log(error);
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({ status: "error" }))
            } else {
                db.query('UPDATE food SET ? WHERE activityid = ?', [{ status: 1 }, activityid], (err12, data12) => {
                    if (err12) {
                        res.setHeader('Content-Type', 'application/json');
                        res.send(JSON.stringify({ status: "error" }))
                    } else {

                        console.log(regdate);

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates= ?', [regdate], async (error11, datas11) => {
                            tactivity = datas11[0]['food'];
                            console.log(tactivity);
                            tactivity = tactivity - 1;
                            console.log(tactivity);

                            if (datas11) {

                                db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ food: tactivity }, regdate], (err16, data16) => {
                                    if (err16) {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "error" }))
                                    } else {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "success" }))
                                    }

                                });
                            } else {
                                res.setHeader('Content-Type', 'application/json');
                                res.send(JSON.stringify({ status: "error" }))
                            }




                        });


                    }

                });

            }

        });

    }
    if (frequency == 2) {
        db.query('ALTER TABLE ' + logs + ' DROP COLUMN ' + activityid, async (error, datas) => {
            if (error) {
                console.log(error);
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({ status: "error" }))
            } else {
                db.query('UPDATE food SET ? WHERE activityid = ?', [{ status: 1 }, activityid], (err12, data12) => {
                    if (err12) {
                        res.setHeader('Content-Type', 'application/json');
                        res.send(JSON.stringify({ status: "error" }))
                    } else {

                        console.log(regdate);

                        db.query('SELECT * FROM ' + fuid + ' WHERE dates = ?', [date], async (error11, datas11) => {
                            tactivity = datas11[0]['food'];
                            console.log(tactivity);
                            tactivity = tactivity - 1;
                            console.log(tactivity);
                            id = datas11[0]['id'];

                            if (error11) {
                                res.setHeader('Content-Type', 'application/json');
                                res.send(JSON.stringify({ status: "error" }))
                            } else {


                                db.query('UPDATE ' + fuid + ' SET ? WHERE dates = ?', [{ food: tactivity }, date], (err12, data12) => {
                                    if (err12) {
                                        res.setHeader('Content-Type', 'application/json');
                                        res.send(JSON.stringify({ status: "error" }))
                                    } else {
                                        id = id + 1;
                                        console.log("nextid");
                                        console.log(id);


                                        db.query('SELECT * FROM ' + fuid + ' WHERE id= ?', [id], async (error13, datas13) => {
                                            if (error13) {
                                                console.log(error13);
                                                res.setHeader('Content-Type', 'application/json');
                                                res.send(JSON.stringify({ status: "error" }))
                                            }
                                            nactivity = datas13[0]['food'];
                                            nactivity = nactivity - 1;
                                            console.log(id);
                                            console.log(nactivity);


                                            db.query('UPDATE ' + fuid + ' SET ? WHERE id = ?', [{ food: nactivity }, id], (err14, data14) => {
                                                if (err14) {
                                                    res.setHeader('Content-Type', 'application/json');
                                                    res.send(JSON.stringify({ status: "error" }))
                                                } else {

                                                    id = id + 1;
                                                    console.log("lastid");
                                                    console.log(id);


                                                    db.query('SELECT * FROM ' + fuid + ' WHERE id= ?', [id], async (error15, datas15) => {
                                                        lactivity = datas15[0]['food'];
                                                        lactivity = lactivity - 1;


                                                        db.query('UPDATE ' + fuid + ' SET ? WHERE id >= ?', [{ food: lactivity }, id], (err16, data14) => {
                                                            if (err16) {
                                                                res.setHeader('Content-Type', 'application/json');
                                                                res.send(JSON.stringify({ status: "error" }))
                                                            } else {
                                                                res.setHeader('Content-Type', 'application/json');
                                                                res.send(JSON.stringify({ status: "success" }))
                                                            }
                                                        });



                                                    });
                                                }
                                            });



                                        });
                                    }

                                });

                            }

                        });


                    }

                });

            }

        });


    }
});


//*********************************Send OTP******************************** */



app.post("/resetotp", (req, res) => {
    const { email, mailotp } = req.body;

    db.query('UPDATE otp set emailotp=? where email=?', [mailotp, email], async (error, datas) => {
        if (error) {
            console.log(error);
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        } else {

            const DOMAIN = "alzunified.live";
            const mg = "7144572cfab3e9f8f4c1fbefc29114dd-413e373c-28b30d90";
            const mailgun = require('mailgun-js')
                ({ apiKey: mg, domain: DOMAIN, host: "api.eu.mailgun.net" });

            sendMail = function (sender_email, receiver_email,
                email_subject, email_body) {

                const n1 = 30;

                const data = {
                    "from": sender_email,
                    "to": receiver_email,
                    "subject": email_subject,
                    "html": '<body style="background-color:#EEEEEE"><div class="container" style="margin-left:5%;margin-right:5%;background-color:#FFFFFF" ><div class="container" style="margin-left:30px;margin-right:30px"><br><br><h2 style="color:black;">  Welcome to Saver Dost</h2><a style="color:black;">Curated offers for everyone</a></div><br><br><br><center><img src="https://incredible-biscochitos-0f6929.netlify.app/applogo.png" style="width:40%" alt="Logo"></center><br><br><div class="container" style="margin-left:30px;margin-right:30px;line-height: 1.7;"><h3 style="color:black;">Dear ' + email + ',</h3><div style="  text-align: justify;text-justify: inter-word;">   <a style="color:black;text-align:justify">Thank you for choosing Saver Dost. Use the following OTP to reset your password. OTP is valid for 24 Hours. OTP is ' + mailotp + '</a><br></div>  </div><br><div class="new" style="margin-left:30px;line-height: 1.5;margin-right:30px">  <br><b style="color:black;">Best Regards,</b><br><a style="letter-spacing:0.4;color:black">Saver Dost Team.</a><br><a style="letter-spacing:0.4;color:black;">info@saverdost.in</a></div><br><br><center>      <div class="fc" style="padding-left:30px;padding-right:30px;">        <a style="color:black;">© 2023 - All rights reserved by Saver Dost</a></div><br><div class="new" style="height:30px;"></div></center> </div><br><br></body>'



                };

                mailgun.messages().send(data, (error, body) => {
                    if (error) console.log(error)
                    else console.log(body);
                });
            }

            let sender_email = 'Excited User <mailgun@sandbox-123.mailgun.org>'
            let receiver_email = email
            let email_subject = 'Welcome to Saver Dost - Reset Password'
            let email_body = 'Greetings from Saver Dost'

            // User-defined function to send email
            sendMail(sender_email, receiver_email,
                email_subject, email_body)


            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "success" }))

        }

    });
});




//************************************************Update dashboard status*/

app.post("/updateolddate", (req, res) => {
    const { uid, date } = req.body;

    db.query('UPDATE activities SET status =1 WHERE uid = ? and date < ? and frequency = 0 or frequency =1 ', [uid, date], async (error, datas) => {

        if (error) {
            console.log(error);
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        } else {
            db.query('UPDATE food SET status =1 WHERE uid = ? and date < ? and frequency = 0 or frequency =1 ', [uid, date], async (error1, datas1) => {

                if (error1) {
                    console.log(error);
                    res.setHeader('Content-Type', 'application/json');
                    res.send(JSON.stringify({ status: "error" }))
                } else {
                    db.query('UPDATE medicines SET status =1 WHERE uid = ? and date < ? and frequency = 0 or frequency =1 ', [uid, date], async (error2, datas2) => {
                        if (error2) {
                            console.log(error);
                            res.setHeader('Content-Type', 'application/json');
                            res.send(JSON.stringify({ status: "error" }))
                        } else {
                            res.setHeader('Content-Type', 'application/json');
                            res.send(JSON.stringify({ status: "success" }))
                        }

                    });
                }

            });

        }

    });
});



//****************************************Upload Image */

app.post("/uploadimg", (req, res) => {
    const { email, uid, images } = req.body;

    db.query('UPDATE register set profileimg=?,profile=1 where email=? AND uid=?', [images, email, uid], async (error, datas) => {
        if (error) {
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        } else {

            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "success" }))
        }
        console.log("Enering pref");






    });
});



//***********************************Insert Message */


app.post("/insertpersonal", (req, res) => {
    const { email, message, name } = req.body;
    let dt = Math.floor(new Date().getTime() / 1000)


    db.query('INSERT INTO forum SET?', { email: email, name: name, status: 1, message: message, date: dt }, (err, data1) => {

        if (err) {
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        } else {
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "success" }))
        }



    });


});

//***************************************************Get MSG************************************************ */

app.post("/getmsg", (req, res) => {
    const { email } = req.body;

    db.query('SELECT * FROM forum WHERE status=1', async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

    });
});

//***************************************************App Notification************************************************ */

app.post("/appnotification", (req, res) => {

    db.query('SELECT * FROM activities WHERE status=0', async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

    });
});



//***************************************************Verify Account************************************************ */

app.post("/verifyaccount", (req, res) => {
    const { email, mailotp } = req.body;

    db.query('SELECT * FROM otp WHERE email=?', [email], async (error, datas) => {
        if (error) {
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        } else {
            if (datas.length > 0) {

                if (datas[0]['emailotp'] == mailotp) {

                    db.query('UPDATE register set verification=1 where email=?', [email], async (error1, datas1) => {
                        if (error1) {
                            res.setHeader('Content-Type', 'application/json');
                            res.send(JSON.stringify({ status: "error" }))
                        } else {

                            db.query('UPDATE otp set emailotp=23 where email=?', [email], async (error2, datas2) => {
                                if (error2) {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "error" }))
                                } else {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "success" }))
                                }
                                //registered = JSON.parse(data1);


                            });


                        }


                    });


                } else {
                    res.setHeader('Content-Type', 'application/json');
                    res.send(JSON.stringify({ status: "error" }))
                }
            } else {
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({ status: "error" }))
            }

        }


    });
});



//**********************************************************Delete MSg****************************** */


app.post("/deletemsg", (req, res) => {
    const { status, id } = req.body;

    db.query('UPDATE forum set status=? where id=?', [status, id], async (error, datas) => {
        if (error) {
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        } else {
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "success" }))
        }
        //registered = JSON.parse(data1);


    });
});






//*********************************Send OTP******************************** */



app.post("/verifyotp", (req, res) => {
    const { email, mailotp, referenceid } = req.body;

    db.query('UPDATE otp set emailotp=? where email=?', [mailotp, email], async (error, datas) => {
        if (error) {
            console.log(error);
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        } else {

            const DOMAIN = "alzunified.live";
            const mg = "7144572cfab3e9f8f4c1fbefc29114dd-413e373c-28b30d90";
            const mailgun = require('mailgun-js')
                ({ apiKey: mg, domain: DOMAIN, host: "api.eu.mailgun.net" });

            sendMail = function (sender_email, receiver_email,
                email_subject, email_body) {

                const n1 = 30;

                const data = {
                    "from": sender_email,
                    "to": receiver_email,
                    "subject": email_subject,
                    "html": '<body style="background-color:#EEEEEE"><div class="container" style="margin-left:30px;margin-right:30px"><br><br><h2 style="color:black;">  Welcome to Alzunified</h2></div><div class="container" style="margin-left:30px;margin-right:30px;line-height: 1.7;"><h3 style="color:black;">Dear ' + email + ',</h3><div style="  text-align: justify;text-justify: inter-word;">   <a style="color:black;text-align:justify">Thank you for choosing Alzunified. Use the following OTP (Ref No: ' + referenceid + ' ) to verify your account. OTP is valid for 24 Hours. OTP is ' + mailotp + '</a><br></div>  </div><br><div class="new" style="margin-left:30px;line-height: 1.5;margin-right:30px">  <br><b style="color:black;">Best Regards,</b><br><a style="letter-spacing:0.4;color:black">Alzunified Team.</a></div><br><br><center>      <div class="fc" style="padding-left:30px;padding-right:30px;">        <a style="color:black;">© 2023 - All rights reserved by Alzunified</a></div><br><div class="new" style="height:30px;"></div></center> </div><br><br></body>'



                };

                mailgun.messages().send(data, (error, body) => {
                    if (error) console.log(error)
                    else console.log(body);
                });
            }

            let sender_email = 'No-Reply <no-reply@alzunified.live>'
            let receiver_email = email
            let email_subject = 'Welcome to Alzunified - Verify Account'
            let email_body = 'Greetings from Alzunified'

            // User-defined function to send email
            sendMail(sender_email, receiver_email,
                email_subject, email_body)


            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "success" }))

        }

    });
});




//*********************************Forget OTP******************************** */



app.post("/forgetotp", (req, res) => {
    const { email, mailotp, referenceid } = req.body;

    db.query('SELECT email FROM register WHERE email=?', [email], async (error45, datas45) => {

        if (error45) {
            console.log(error45);
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        } else {
            if (datas45.length > 0) {

                db.query('UPDATE otp set emailotp=? where email=?', [mailotp, email], async (error, datas) => {
                    if (error) {
                        console.log(error);
                        res.setHeader('Content-Type', 'application/json');
                        res.send(JSON.stringify({ status: "error" }))
                    } else {

                        const DOMAIN = "alzunified.live";
                        const mg = "7144572cfab3e9f8f4c1fbefc29114dd-413e373c-28b30d90";
                        const mailgun = require('mailgun-js')
                            ({ apiKey: mg, domain: DOMAIN, host: "api.eu.mailgun.net" });

                        sendMail = function (sender_email, receiver_email,
                            email_subject, email_body) {

                            const n1 = 30;

                            const data = {
                                "from": sender_email,
                                "to": receiver_email,
                                "subject": email_subject,
                                "html": '<body style="background-color:#EEEEEE"><div class="container" style="margin-left:30px;margin-right:30px"><br><br><h2 style="color:black;">  Welcome to Alzunified</h2></div><div class="container" style="margin-left:30px;margin-right:30px;line-height: 1.7;"><h3 style="color:black;">Dear ' + email + ',</h3><div style="  text-align: justify;text-justify: inter-word;">   <a style="color:black;text-align:justify">Thank you for choosing Alzunified. Use the following OTP (Ref No: ' + referenceid + ' ) to reset your password. OTP is valid for 24 Hours. OTP is ' + mailotp + '</a><br></div>  </div><br><div class="new" style="margin-left:30px;line-height: 1.5;margin-right:30px">  <br><b style="color:black;">Best Regards,</b><br><a style="letter-spacing:0.4;color:black">Alzunified Team.</a></div><br><br><center>      <div class="fc" style="padding-left:30px;padding-right:30px;">        <a style="color:black;">© 2023 - All rights reserved by Alzunified</a></div><br><div class="new" style="height:30px;"></div></center> </div><br><br></body>'



                            };

                            mailgun.messages().send(data, (error, body) => {
                                if (error) console.log(error)
                                else console.log(body);
                            });
                        }

                        let sender_email = 'No-Reply <no-reply@alzunified.live>'
                        let receiver_email = email
                        let email_subject = 'Welcome to Alzunified - Reset Password'
                        let email_body = 'Greetings from Alzunified'

                        // User-defined function to send email
                        sendMail(sender_email, receiver_email,
                            email_subject, email_body)


                        res.setHeader('Content-Type', 'application/json');
                        res.send(JSON.stringify({ status: "success" }))

                    }

                });
            } else {
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({ status: "error" }))
            }
        }



    });

});



//***************************************************App Notification************************************************ */

app.post("/appnotification", (req, res) => {
    const { uid } = req.body;

    db.query('SELECT * FROM activities WHERE uid=1 and status=0', [uid], async (error, datas) => {
        console.log(datas);
        //registered = JSON.parse(data1);
        res.send(datas)

    });
});



//***************************************************Reset Password************************************************ */

app.post("/resetpassword", (req, res) => {
    const { email, mailotp, password } = req.body;

    db.query('SELECT * FROM otp WHERE email=?', [email], async (error, datas) => {
        let hashedPassword = await bcrypt.hash(password, 8);
        if (error) {
            console.log(error);
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        } else {
            if (datas.length > 0) {

                if (datas[0]['emailotp'] == mailotp) {

                    db.query('UPDATE register set password=? where email=?', [hashedPassword, email], async (error1, datas1) => {
                        if (error1) {
                            console.log("Update Error");
                            res.setHeader('Content-Type', 'application/json');
                            res.send(JSON.stringify({ status: "error" }))
                        } else {

                            db.query('UPDATE otp set emailotp=23 where email=?', [email], async (error2, datas2) => {
                                if (error2) {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "error" }))
                                } else {
                                    res.setHeader('Content-Type', 'application/json');
                                    res.send(JSON.stringify({ status: "success" }))
                                }
                                //registered = JSON.parse(data1);


                            });


                        }


                    });


                } else {
                    console.log("OTP Error");
                    res.setHeader('Content-Type', 'application/json');
                    res.send(JSON.stringify({ status: "error" }))
                }
            } else {
                console.log("Length Error");
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({ status: "error" }))
            }

        }


    });
});


//***************************************************Delete Account************************************************ */

app.post("/deleteaccount", (req, res) => {
    const { email } = req.body;

    db.query('UPDATE register set block=1 where email=?', [email], async (error, datas) => {
        if (error) {
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        } else {
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "success" }))
        }
    });
});

//***************************************************Update Emergency************************************************ */

app.post("/updateemergency", (req, res) => {
    const { emergency, email } = req.body;

    db.query('UPDATE register set emergencyemail=? where email=?', [emergency, email], async (error, datas) => {
        if (error) {
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "error" }))
        } else {
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ status: "success" }))
        }
    });
});




//*********************************Send Emergency******************************** */



app.post("/emergencyemail", (req, res) => {
    const { email, fromemail,ftime } = req.body;



    const DOMAIN = "alzunified.live";
    const mg = "7144572cfab3e9f8f4c1fbefc29114dd-413e373c-28b30d90";
    const mailgun = require('mailgun-js')
        ({ apiKey: mg, domain: DOMAIN, host: "api.eu.mailgun.net" });

    sendMail = function (sender_email, receiver_email,
        email_subject, email_body) {

        const n1 = 30;

        const data = {
            "from": sender_email,
            "to": receiver_email,
            "subject": email_subject,
            "html": '<body style="background-color:#EEEEEE"><div class="container" style="margin-left:30px;margin-right:30px"><br><br><h2 style="color:black;">  Welcome to Alzunified</h2></div><div class="container" style="margin-left:30px;margin-right:30px;line-height: 1.7;"><h3 style="color:black;">Dear ' + email + ',</h3><div style="  text-align: justify;text-justify: inter-word;">   <a style="color:black;text-align:justify">Thank you for choosing Alzunified. The emergency help required by (email: ' + fromemail + ' ) at Time ' + ftime + '</a><br></div>  </div><br><div class="new" style="margin-left:30px;line-height: 1.5;margin-right:30px">  <br><b style="color:black;">Best Regards,</b><br><a style="letter-spacing:0.4;color:black">Alzunified Team.</a></div><br><br><center>      <div class="fc" style="padding-left:30px;padding-right:30px;">        <a style="color:black;">© 2023 - All rights reserved by Alzunified</a></div><br><div class="new" style="height:30px;"></div></center> </div><br><br></body>'



        };

        mailgun.messages().send(data, (error, body) => {
            if (error) console.log(error)
            else console.log(body);
        });
    }

    let sender_email = 'No-Reply <no-reply@alzunified.live>'
    let receiver_email = email
    let email_subject = 'Welcome to Alzunified - Emergency'
    let email_body = 'Greetings from Alzunified'

    // User-defined function to send email
    sendMail(sender_email, receiver_email,
        email_subject, email_body)


    res.setHeader('Content-Type', 'application/json');
    res.send(JSON.stringify({ status: "success" }))



});
