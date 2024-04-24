//src/controller/apiController.js
import loginRegisterService from "../service/loginRegisterService";
const handleRegister = async(req, res) => {
    try {
            // if(req.body.password && req.body.password.length < 4) {
            //     return res.status(200).json({
            //         EM : 'Missing required parameters',
            //         EC: '1',
            //         DT:''
                
            //     })
            // }
            // if(!req.body.phone || !req.body.password) {
            //     return res.status(200).json({
            //         EM : 'your password must have more than 3 letter',
            //         EC: '1',
            //         DT:''
                
            //     })
            // }
            if(!req.body.phone ) {
                return res.status(200).json({
                    EM : 'no phone',
                    EC: '1',
                    DT:''
                
                })
            }
            // service : create user
            let data = await loginRegisterService.registerNewUser(req.body);
            return res.status(200).json({
                EM : data.EM,
                EC: data.EC,
                DT:''
            
            })

    }catch(e){
        return res.status(500).json({
            EM : 'error from server',
            EC: '-1',
            DT:''
        
        })
    }
    }
    const handleLogin = async(req,res)=> {
        try {
           let data= await loginRegisterService.handleUserLogin(req.body);
            //set cookie 
            if(data && data.DT && data.DT.access_token) 
           { res.cookie("jwt", data.DT.access_token, {httpOnly: true , maxAge: 60*60*1000});}
            return res.status(200).json({
                EM : data.EM,
                EC: data.EC,
                DT: data.DT
            })

    }catch(e){
        return res.status(500).json({
            EM : 'error from server',
            EC: '-1',
            DT:''
        
        })
    }
    }
    const handleLogout=async (req,res)=>{
        try {
            res.clearCookie("jwt");
             return res.status(200).json({
                 EM : 'Đăng xuất thành công!!',
                 EC: 0,
                 DT: ''
         
             })
 
     }catch(e){
         return res.status(500).json({
             EM : 'error from server',
             EC: '-1',
             DT:''
         
         })
     }
    }
    const changePassword=async (req,res)=>{
        try {
            let data = await loginRegisterService.changePassword(req.body);
            if (data) {
              return res.status(200).json({
                EM: data.EM,
                EC: data.EC,
                DT: data.DT,
              });
            }
          } catch (e) {
            return res.status(500).json({
              EM: "error from server",
              EC: "-1",
              DT: "",
            });
          }
    }
module.exports = {
    handleRegister,
    handleLogin,
    handleLogout,
    changePassword
}