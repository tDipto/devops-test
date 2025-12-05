import axios from "axios";

export default function createChannel() {
    const controller = new AbortController();
    const token = localStorage.getItem("r-token");
    const request = axios.create({
        baseURL: process.env.REACT_APP_API_URL,
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
        },
        withCredentials: true,
        signal: controller.signal,
    });
    return { request, controller }
};