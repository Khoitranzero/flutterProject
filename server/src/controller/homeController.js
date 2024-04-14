import userService from '../service/userService';




const handleHelloWorld = (req, res)=> {
    return res.render("home.ejs");
}

const handleUserPage = async(req, res) => {
    let userList = await userService.getUserList();
     await userService.deleteUser(2);
  
    return res.render("user.ejs",{userList});
}
const handlCreateNewUser = (req, res) => {
    let userId = req.body.userId;
    let password = req.body.password;
    let username = req.body.username;
userService.createNewUser(userId,password,username)
userService.getUserList();
    return res.redirect("/user");
  
}
const handleDeleteUser = async(req, res) => {
    await userService.deleteUser(req.params.userId);
    return res.redirect("/user");
}
const getUpdateUserPage = async(req, res) => {
    let userId = req.params.userId;
    let user = await userService.getUserById(userId);
    let userData = {};
    userData = user;
    
    return res.render("user-update.ejs", {userData});
    
}
const handlUpdateUser =async(req, res) => {
    let userId = req.body.userId;
    let username = req.body.username;
await userService.updateUserInfor(username, userId);
    return res.redirect("/user");
}
module.exports = {
    handleHelloWorld, handleUserPage, handlCreateNewUser, handleDeleteUser, getUpdateUserPage, handlUpdateUser
}