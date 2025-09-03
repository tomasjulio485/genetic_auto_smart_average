import streamlit as st
import re
import numpy as np

st.title("Weighted Vector Calculator")

# Inputs
input_text = st.text_area("Paste your region data here...", height=300)
custom_name = st.text_input("Output Name Prefix (e.g., SRUBNAYA_)", value="AVERAGE_")

# Button to run calculation
if st.button("Calculate Weighted Average"):
    text = input_text.strip()
    custom_name_clean = custom_name.strip().upper().replace(" ", "_")

    weighted_vectors = []
    weights = []

    error = None

    for line in text.splitlines():
        if not line.strip():
            continue
        try:
            # Match name and weight
            name_match = re.match(r'^(.+?)_\(N=(\d+)\),', line)
            if not name_match:
                continue

            n = int(name_match.group(2))
            vector_str = line.split(',', 1)[1]
            vector = list(map(float, vector_str.strip().split(',')))

            weighted_vectors.append(np.array(vector) * n)
            weights.append(n)
        except Exception as e:
            error = f"❌ Error processing line: {line}\n   {e}"
            break

    if error:
        st.error(error)
    elif weighted_vectors and weights:
        total_weight = sum(weights)
        summed_vector = sum(weighted_vectors)
        weighted_avg_vector = summed_vector / total_weight

        # Format output
        formatted_vector = ",".join(f"{x:.8f}" for x in weighted_avg_vector)
        result_line = f"{custom_name_clean}__(N={total_weight}),{formatted_vector}"

        st.success("Calculation complete!")
        st.text_area("Result", value=result_line, height=100)
    else:
        st.warning("❌ No valid data found. Please check your input format.")
