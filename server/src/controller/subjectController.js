//src/controller/subjectController.js
import subjectService from '../service/subjectService';
const readFunc = async(req, res)=>{
try {
    let data=await subjectService.getSubject();

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
};

const createFunc =async(req,res)=>{
 
    try {
        let data=await subjectService.createNewSubject(req.body);
        return res.status(200).json({
            EM :data.EM,
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
        let data=await subjectService.updateSubject(req.body);
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
        let data =await subjectService.deleteSubject(req.body.subjectId);
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

module.exports={
    readFunc,createFunc,updateFunc,deleteFunc
}