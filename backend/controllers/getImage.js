import fs from 'fs';
import path from 'path';

const getImage = async (req, res, next) => {
    let {row,col,picid} = req.query;
    if(isNaN(row) || isNaN(col) || isNaN(picid)){
    res.status(202).send('Wroung url')
    return
    }
    // const imagePath = path.join(__dirname, 'path/to/your/image.jpeg');D:\gpa\backend\static\cat1
    const image = fs.readFileSync(path.join(process.cwd(),"static/cat"+`${picid}/${row}_${col}.jpeg`));
    res.setHeader('Content-Type', 'image/jpeg');
    res.end(image, 'binary');
    // res.send(splitArrays)
}

export { getImage }
