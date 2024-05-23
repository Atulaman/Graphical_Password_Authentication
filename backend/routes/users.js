import express from 'express'
import { loginController } from '../controllers/users_login.js'
import { signupController } from '../controllers/users_signup.js'
import { check } from '../controllers/validation.js'
import ImageSplit from '../controllers/split_image.js'

const router = express.Router()

router.post('/signup', signupController)
router.post('/login', loginController)
router.get('/imagesplit', ImageSplit)
router.get('/check', check)

export { router }