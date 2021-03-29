/**
 * Common functions for Mongodb
 *
 * Just load(common.js) before call functions.
 * add load(<path>/common.js) in ~/.mongorc.js for mongo shell
 */

/**********************
 * Format Date Field
 */
function formatDate(d) {
    var month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear(),
        hour = "" + d.getHours(),
        mins = "" + d.getMinutes();

    if (month.length < 2) 
        month = '0' + month;
    if (day.length < 2) 
        day = '0' + day;
    if (hour.length < 2) 
        hour = '0' + hour;
    if (mins.length < 2) 
        mins = '0' + mins;

    return [year, month, day].join('-') + " " + hour + ":" + mins;
}
