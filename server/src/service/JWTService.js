//src/service/JWTService.js
import db from "../models/index";

const getClassName = async( user)=>{
let classNames = await db.Class.findOne({
    where : {id : user.classId},
    attributes : ["id", "className"] 
})
return classNames ? classNames : {};
}
const getSubjectName = async( point)=>{
    let subjectName = await db.Subject.findOne({
        where : {id : point.subjectId},
        attributes : ["id", "subjectName"] 
    })
    return subjectName ? subjectName : {};
    }
module.exports={
    getClassName,getSubjectName
}