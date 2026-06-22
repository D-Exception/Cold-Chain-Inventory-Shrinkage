\# Cold-Chain Shrinkage Analysis for Company X



\## Project Overview

\*\*Role:\*\* Data Analyst  

\*\*Focus:\*\* Stock loss detection, supplier performance, warehouse control, and operational risk reduction



Company X needed a clearer picture of where inventory was being lost across its cold chain operations. The business problem was not simply “what is missing,” but \*\*where it is missing, why it is missing, and which parts of the supply chain are driving the loss\*\*.



This analysis examined the full product journey, from supplier purchase orders to warehouse transfers, storage conditions, and stock write-offs. The goal was to identify the main drivers of shrinkage, isolate the weakest control points, and provide practical actions that could help Company X protect stock value and strengthen operational control.



\---



\## Business Problem

Company X lacked a clear, measurable view of inventory loss across its cold-chain network. As a result, the business could not easily determine:



\- where shrinkage was occurring,

\- which suppliers were contributing most to loss,

\- whether losses were happening during receipt, transfer, or storage,

\- and which operational areas should be prioritized for improvement.



Without this visibility, inventory losses could continue unchecked, reducing stock accuracy, increasing spoilage risk, and weakening supply chain reliability.



\---



\## Dataset Description

The analysis used seven related CSV sheets:



\- \*\*suppliers\_coldchain\*\* — supplier details, lead times, and metadata

\- \*\*products\_coldchain\*\* — product attributes such as shelf life, supplier, and storage temperature requirements

\- \*\*purchase\_orders\_coldchain\*\* — purchase order tracking and order status

\- \*\*purchase\_order\_lines\_coldchain\*\* — line-level purchasing transactions

\- \*\*stock\_movements\_coldchain\*\* — inventory movement across the cold chain network

\- \*\*cycle\_counts\_coldchain\*\* — system and physical inventory counts

\- \*\*temperature\_logs\_coldchain\*\* — warehouse temperature and humidity records



Each sheet represented a different stage of the inventory lifecycle and helped build a complete view of how goods moved through the business.



\---



\## Cleaning Summary

A detailed cleaning and validation process was carried out before analysis.



\### Supplier, Product, and Purchase Order Data

\- Duplicate records were removed from the supplier, product, and purchase order sheets.

\- Text fields were standardized using proper text formatting to improve consistency and usability.



\### Purchase Order Lines

This sheet was validated more deeply through calculated checks.



\- Two validation columns were added:

&#x20; - `line\_total\_actual`

&#x20; - `line\_total\_check`



These were used to recalculate expected totals and compare them against the recorded values.  

This process flagged \*\*6 line total errors\*\*, improving confidence in the accuracy of purchasing data.



\### Stock Movements

This sheet was also rebuilt for traceability.



\- Duplicate records were removed.

\- Two validation columns were added:

&#x20; - `missing\_reference\_id\_check`

&#x20; - `reference\_id\_actual`



These checks recovered \*\*4 missing reference IDs\*\*, which improved data completeness and tracking integrity.



\### Cycle Counts

\- Duplicate records were removed.

\- Two validation columns were added:

&#x20; - `system\_qty\_check`

&#x20; - `variance\_check`



Both checks confirmed that:

\- \*\*100% of system quantity values passed validation\*\*

\- \*\*100% of variance values passed validation\*\*



This indicated strong reliability in the inventory count data.



\---



\## Key Insights

\### 1. The main loss point is before or during receipt from suppliers

Over the three-month period from January to March, Company X placed \*\*more than 420 orders\*\* for different products.



\- \*\*Total units ordered:\*\* 53,957

\- \*\*Total units received:\*\* 36,198



This represents approximately \*\*33% shrinkage\*\*.



That level of loss is significant. It suggests the largest issue is occurring \*\*before goods fully enter Company X’s control\*\*, most likely during supplier fulfillment, transport, unloading, or receipt verification.



\### 2. Supplier performance is uneven

Supplier performance varied materially across the network.



\- \*\*Most used supplier:\*\* SUP00013  

&#x20; - Units ordered: 2,237  

&#x20; - Units received: 1,619  

&#x20; - Fulfillment rate: \~72%



\- \*\*Top 10 suppliers combined:\*\*  

&#x20; - Units ordered: 13,404  

&#x20; - Units received: 8,951  

&#x20; - Fulfillment rate: \~67%



This shows that even the suppliers used most often are contributing heavily to shrinkage.



\### 3. Internal warehouse transfers are not the problem

The internal transfer analysis showed:



\- \*\*0 shrinkage occurred during warehouse-to-warehouse movement\*\*



This is an important control insight because it removes internal transfer as a major source of loss and shifts attention back to supplier-side delivery and receiving.



\### 4. Storage loss is minimal, but not zero

\- \*\*Damaged packaging / tampering:\*\* 44 units written off

\- \*\*Temperature excursion:\*\* 36 units lost



Given that Company X received \*\*36,198 units\*\*, these losses represent \*\*less than 1% shrinkage\*\* each.



Storage controls appear generally strong, but they still require ongoing monitoring.



\### 5. Warehouse health still needs attention

Three warehouses showed sensor-offline risk:



\- WH-PHC-01

\- WH-IBA-01

\- WH-BEN-01



Even where losses are low, offline sensors create exposure and should be treated as an operational warning sign.



\---



\## Recommendations

\### 1. Establish a receiving control system

Create a formal receiving process that records exactly how much stock arrives, in what condition, and whether it matches the order.



\### 2. Introduce supplier performance tracking

Track supplier-level:

\- fulfillment rate,

\- delivery accuracy,

\- recurring shortages,

\- and shipment quality.



\### 3. Improve chain of custody

Every handover should have a clear owner:



\*\*Supplier → Transporter → Warehouse Receiver → Inventory Team\*\*



\### 4. Seal and track shipments

Large shipments should be sealed and tracked so the business can confirm whether goods were opened, altered, or tampered with during transit.



\### 5. Separate types of shrinkage

Track supplier shortage, transport loss, warehouse damage, and internal theft separately so that corrective action matches the actual issue.



\### 6. Perform monthly root cause analysis

Shrinkage should not only be recorded; it should be explained.  

A monthly review will help Company X:

\- identify repeating patterns,

\- validate corrective actions,

\- monitor supplier and warehouse trends,

\- and improve operational control over time.



\---



\## Tools Used

\- \*\*Excel\*\*  

&#x20; - Power Query  

&#x20; - Power Pivot  



\- \*\*MySQL Workbench\*\*



\- \*\*Power BI\*\*  

&#x20; - DAX  

&#x20; - Data Modeling



\---

