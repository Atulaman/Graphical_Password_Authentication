import sharp from 'sharp';
export default async function ImageSplit(req, res, next) {
  let inputPath = path.join(process.cwd(),"static/cats/cats3.jpeg")
    // "/home/techcompiler/Documents/prsnl/graphical-password-authentication/img/auth_success.png";
  let outputPath = "static/cat3";
  let n = 4;
  // Function to split image into n x n squares
  try {
    // Read the input image
    const image = sharp(inputPath);
    // Get image metadata to determine dimensions
    const metadata = await image.metadata();
    const { width, height } = metadata;
    
    // Calculate the size of each square
    const squareSize = Math.floor(Math.min(width, height) / n);

    // Loop through each row
    for (let row = 0; row < n; row++) {
      // Loop through each column
      for (let col = 0; col < n; col++) {
        // Calculate the coordinates for the current square
        const left = col * squareSize;
        const top = row * squareSize;
        // Extract the current square from the image
        let image1 = sharp(inputPath)
        const square = image1.extract({
          left:left,
          top: top,
          width: squareSize,
          height: squareSize,
        });

        // Save the square as a new image
        await square.toFile(`${outputPath}/${row}_${col}.jpeg`);

      }
    }

    console.log(`Image successfully split into ${n} x ${n} squares.`);
    res.send("image splitted !")
  } catch (err) {
    console.error("Error:", err);
    res.send("error")
  }
}

  // async()=> {
  // try {
  //   const chunckSize = 100;
  //   const chuncks = await imageToChunks('/home/techcompiler/Documents/prsnl/graphical-password-authentication/img/auth_success.png',chunckSize);
  //   console.log('Number of chunks', chuncks.length);

  //   let i = 0;
  //   chuncks.forEach(c => {
  //     i++;
  //     fs.writeFileSync(`slice_${i}.png`,c);
  //   });
  //   res.send('splitted image !')
  // } catch (e) {
  //   console.log(e);
  //   res.status(200).json({"error ":e})
  // }

