import axios from "axios"

const predict = (async (req, res) => {
    console.log(req)
    if(req.body === undefined || req.body.text === undefined) {
        return res.status(400).json({ error: "Invalid input, 'text' field is required" });
    }
    const { text } = req.body;
    try {
        const response = await axios.post(`${process.env.ML_API_URL}/predict`, {
            text
        })
        return res.status(200).json(response.data);

    } catch (error) {
        console.error(error)
        return res.status(500).json({ error: "Error communicating with ML API" });
    }
})

export default predict;