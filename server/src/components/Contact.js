import {useState} from "react";
import validator from "validator/es";
import {successToast, Toast} from "../util/toast";
import axios from "axios";
//import {api} from "../static/config";
import { BASE_URL } from "../constant";

export default function Contact(props) {

    const [data, setData] = useState({
        name: "",
        email: "",
        message: ""
    })

    function handleChange(event) {
        setData(prev => {
            return {...prev,[event.target.name]: event.target.value.trim()}
        })
    }

    function handleSubmit() {
        if (!validateData()) return
        props.setLoading(true)
        axios.post(`${BASE_URL}/api/contact`, data)
            .then(res => {
                props.setLoading(false)
                successToast("Message Sent Successfully, Thanks !!")
                clearData()
            })
            .catch(err => Toast(err.response.data.message))
    }

    function clearData() {
        setData({
            name: "",
            email: "",
            message: ""
        })
    }

    function validateData() {
        if (data.name.length < 3) {
            Toast("You entered an invalid Name !")
            return false
        }
        if (!validator.isEmail(data.email)) {
            Toast("You entered an invalid email !")
            return false
        }
        if (data.message.length < 3) {
            Toast("You entered an invalid Message !")
            return false
        }
        return true
    }

    return (
        <div className="h-full flex sm:flex-row flex-col justify-center font-['Work_Sans'] mt-12">
            <div className="hidden sm:flex items-center w-2/5">
                <img className="transition duration-500 ease-in-out hover:scale-95 rounded-xl" alt="" src="https://i.ibb.co/P1zYDgh/image.jpg"/>
            </div>
            <div className="sm:w-2/5">
                <p className="text-2xl sm:text-5xl text-white px-6">Connect With Our team</p>
                <p className="text-xl sm:text-2xl text-gray-300 px-6">We would love to respond to your suggestions/recommendations/queries.</p>
                <p className="text-xl sm:text-2xl text-gray-300 px-6">Feel free to get in touch with Our team.</p>
                <div className="flex flex-col px-6 py-6 mt-4">
                    <div className="mb-4">
                        <p className="sm:text-xl text-white mb-1">Name</p>
                        <input onChange={handleChange} placeholder="Your Name" name="name" value={data.name} className="bg-gray-300 rounded-full h-8 sm:h-12 px-6 font-3xl sm:w-3/4 w-[90%]" type="text"/>
                    </div>
                    <div className="mb-4">
                        <p className="sm:text-xl text-white mb-1">E-mail</p>
                        <input onChange={handleChange} placeholder="email address" name="email" value={data.email} className="bg-gray-300 rounded-full h-8 sm:h-12 px-6 font-3xl sm:w-3/4 w-[90%]" type="email"/>
                    </div>
                    <div>
                        <p className="sm:text-xl text-white mb-1">Your Thoughts/Recommendation</p>
                        <textarea onChange={handleChange} placeholder="message..." name="message" value={data.message} rows="4" className="bg-gray-300 rounded-xl px-2 sm:px-6 font-3xl py-2 sm:w-3/4 w-[90%]" />
                    </div>
                </div>
                <button onClick={handleSubmit} className="w-1/4 ml-6 transition duration-500 ease-in-out h-8 sm:h-12 bg-[#000000] rounded-full sm:px-6 text-white border-2 hover:bg-transparent border-[#000000] sm:font-bold">Send</button>
            </div>

            
        </div>
)
}