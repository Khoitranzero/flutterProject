//src/controller/poinController.js
import pointService from '../service/pointService';
const readFunc = async(req, res)=>{
try {
    let data=await pointService.getPoint();

    return res.status(200).json({
        EM : data.EM,
        EC: data.EC,
        DT: data.DT

    })
    
} catch (error) {
    console.log(error);
    return res.status(500).json({
        EM : 'error from server',
        EC: '-1',
        DT:''
})
}
}
const createFunc =async(req,res)=>{
 
    try {
        let data=await pointService.createNewPoint(req.body);
        return res.status(200).json({
            EM : data.EM,
            EC: data.EC,
            DT: data.DT
    
        })
    } catch (error) {
        return res.status(500).json({
            EM : 'error from server',
            EC: '-1',
            DT:''
    })
    }
}
const updateFunc =async(req,res)=>{
    try {
        let data=await pointService.updatePoint(req.body);
        return res.status(200).json({
            EM : data.EM,
            EC: data.EC,
            DT: data.DT
    
        })
    } catch (error) {
        return res.status(500).json({
            EM : 'error from server',
            EC: '-1',
            DT:''
    })
    }
}
const deleteFunc =async(req,res)=>{
  
    try {
        console.log("first,",req.body)
        // let data =await pointService.deletePoint(req.body.subjectId);
        let data =await pointService.deletePoint(req.body);
        return res.status(200).json({
            EM : data.EM,
            EC: data.EC,
            DT: data.DT
    
        })
    } catch (error) {
            return res.status(500).json({
                EM : 'error from server',
                EC: '-1',
                DT:''
    })
    }
}
// const getUserAccount =async(req,res)=>{
//     return res.status(200).json({
//         EM : 'ok',
//         EC: 0,
//         DT:{
//             access_token:req.token,
//             getClass: req.user.getClass,
//             userId: req.user.userId,
//             username: req.user.username
//         }
// })
// }
module.exports={
    readFunc,createFunc,updateFunc,deleteFunc
}